BIG_PULL_REQUEST_LINES = 1000
APP_FILES = /^(app|lib)/
TEST_FILES = /^(features|spec|test)/

has_app_changes = !git.modified_files.grep(APP_FILES).empty?
has_test_changes = !git.modified_files.grep(TEST_FILES).empty?

# Alias for Check branches
## base
has_base_master = github.branch_for_base == 'master'
has_base_develop = github.branch_for_base == 'develop'
has_base_release_stg = github.branch_for_base == 'release-stg'
has_base_release_prd = github.branch_for_base == 'release-prd'
## head
has_head_release_stg = github.branch_for_head == 'release-stg'
has_head_release_prd = github.branch_for_head == 'release-prd'
has_head_develop = github.branch_for_head == 'develop'
has_head_master = github.branch_for_head == 'master'
has_head_hotfix = github.branch_for_head.match(/^(hotfix)\//)
has_milestone = !github.pr_json["milestone"].nil?
has_label_wip = github.pr_labels.include?('WIP') || github.pr_labels.include?('wip') || github.pr_title.include?('[WIP]') || github.pr_title.include?('[wip]')
has_label_no_ticket = github.pr_labels.include?('no ticket')
has_pr_body_ticket = github.pr_body.match(/## Redmineチケット\s+.*https:\/\/redmine\.fs-bdash\.com\/issues\/\d+.*\s+## やったこと/)
not_has_pr_body_do = github.pr_body.match(/## やったこと\s+## やっていないこと/)
not_has_pr_body_not_do = github.pr_body.match(/## やっていないこと\s+## スクリーンショット/)
not_has_pr_body_screenshot_before = github.pr_body.match(/## スクリーンショット\s+### before\s+### after/)
not_has_pr_body_screenshot_after = github.pr_body.match(/### after\s+## 影響範囲調査結果/)
not_has_pr_body_research = github.pr_body.match(/<details>\s+<summary>確認内容詳細<\/summary>\s+```\s+```\s+<\/details>/)

# Check branches
if has_base_master && !has_head_release_prd
  fail(':evergreen_tree: `master`にmergeできるのは、`release-prd`だけかもしれないー')
end
if has_base_release_prd && !has_head_release_stg && !has_head_hotfix
  warn(':evergreen_tree: `release-prd`にmergeできるのは、`release-stg`or`hotfix/~`だけかもしれないー')
end

# Check TODO
todoist.message = "TODO対応してくれないの？:cry:"
todoist.warn_for_todos
todoist.print_todos_table

# wip
fail(':tiger: このPR、まだWIPだからmergeできないんだけどー') if has_label_wip

# Warn if 'Gemfile' was modified and 'Gemfile.lock' was not
if git.modified_files.include?("Gemfile") && !git.modified_files.include?("Gemfile.lock")
  fail(":tiger: `Gemfile`は更新するなら、`Gemfile.lock`は更新してほしいかもー")
end

if ((has_base_develop || has_base_release_stg) && !has_head_develop) || (has_base_release_prd && !has_head_release_stg)

  ## PR
  fail(':red_circle: 「Milestone」設定しないとダメなの！「Sprint##_YYYYMMDD」この感じなの！') if !has_milestone
  fail(':red_circle: 「Redmineチケット」貼らないとダメなの！') if !has_pr_body_ticket && !has_label_no_ticket
  fail(':red_circle: 「やったこと」かかないとダメなの！') if not_has_pr_body_do
  fail(':red_circle: 「やってないこと」かかないとダメなの！「なし」なら「なし」なの！') if not_has_pr_body_not_do
  fail(':red_circle: 「スクショ（before）」貼らないとダメなの！「なし」なら「なし」なの！') if not_has_pr_body_screenshot_before
  fail(':red_circle: 「スクショ（after）」貼らないとダメなの！「なし」なら「なし」なの！') if not_has_pr_body_screenshot_after
  fail(':red_circle: 「影響範囲調査結果」かかないとダメなの！') if not_has_pr_body_research

end

# Check codes
warn(':mushroom: 1000行以上の修正は、危ないかもだけどー？') if git.lines_of_code > BIG_PULL_REQUEST_LINES
warn(':mushroom: appのコードを修正してるけど、testは書かないのー？') if has_app_changes && !has_test_changes

# a PR without any changes is invalid
if git.modified_files.empty? && git.added_files.empty? && git.deleted_files.empty? && !(has_base_develop && has_head_master)
  message(':mushroom: 何も修正してないかもだけどー？')
end

message(
  "@#{github.pr_author}\n\n"\
  "dangerで失敗した時は、指摘内容を修正して\n"\
  "<a href='https://circleci.com/workflow-run/" + ENV['CIRCLE_WORKFLOW_ID'] + "'>https://circleci.com/workflow-run/" + ENV['CIRCLE_WORKFLOW_ID'] + "</a>\n"\
  "から「Rerun from failed」を実行してなの！\n\n"\
  "急ぎじゃなければ、入力しておいてもらえれば、夜中に確認しておくなの！ :eyes:"
) if !violation_report[:errors].empty?

# add lgtm pic
lgtm.check_lgtm
