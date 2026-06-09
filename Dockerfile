FROM rocketchat/rocket.chat:latest

USER root
RUN printf '%s\n' \
    '#!/bin/sh' \
    'if [ -n "$ROOT_URL" ]; then' \
    '  _h=$(echo "$ROOT_URL" | sed "s|https://||" | sed "s|\.cloud\.nexlayer\.ai||")' \
    '  _d=$(echo "$_h" | cut -d- -f3-)' \
    '  export MONGO_URL="mongodb://${_d}-mongo-service:27017/rocketchat"' \
    '  export MONGO_OPLOG_URL="mongodb://${_d}-mongo-service:27017/local?replicaSet=rs0"' \
    'fi' \
    'exec "$@"' > /nx-start.sh && chmod +x /nx-start.sh
ENTRYPOINT ["/bin/sh", "/nx-start.sh"]
CMD ["node", "main.js"]