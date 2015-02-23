# Rubedo dockerfile
FROM centos:centos7
RUN yum -y update
# Install Supervisor and required packages
RUN yum install -y epel-release; yum -y clean all && \
    yum install -y git supervisor gcc-c++ make bzip2 nodejs npm tar fontconfig; yum -y clean all
RUN mkdir -p /var/run/prerender /var/log/supervisor /var/log/prerender /usr/share/prerender
COPY supervisord.conf /etc/supervisord.conf
#Install Mongo
RUN git clone https://github.com/prerender/prerender.git /usr/share/prerender
RUN cd /usr/share/prerender && \
    npm install && \
    npm install prerender-mongodb-cache --save
RUN ls -l /usr/share/prerender
RUN sed -i "s#// server.use(prerender.s3HtmlCache());#server.use(require('prerender-mongodb-cache'));#g" /usr/share/prerender/server.js && \
    sed -i "s#database.collection('pages', function(err, collection) {#database.collection('pages-prerender', function(err, collection) {#g" /usr/share/prerender/node_modules/prerender-mongodb-cache/lib/mongoCache.js
# Expose port
EXPOSE 3000
CMD ["/usr/bin/supervisord -c /etc/supervisord.conf"]
