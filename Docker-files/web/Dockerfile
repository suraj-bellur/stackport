FROM nginx
LABEL "Project"="Stackport"
LABEL "Author"="Suraj"

RUN rm -rf /etc/nginx/conf.d/default.conf
COPY nginstackportapp.conf /etc/nginx/conf.d/stackportapp.conf