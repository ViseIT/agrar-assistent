# Static "Agrar Assistent" tool — self-contained HTML pages (inline CSS/JS,
# embedded font) that query the public BVL PSM API directly from the browser.
# There is no build step; nginx just serves the files.
FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY *.html /usr/share/nginx/html/

EXPOSE 80
