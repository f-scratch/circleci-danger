if  [ "A${CIRCLE_TAG}" = "A" ] ;then
    version="$(echo ${CIRCLE_SHA1} | cut -c -7)"
else
    version="${CIRCLE_TAG}"
fi