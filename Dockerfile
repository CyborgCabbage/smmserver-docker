FROM python:3.13-slim
WORKDIR /app

# generate certificates and exit blocking call
RUN pip install --no-cache-dir mitmproxy
RUN timeout 5 mitmdump --set confdir=.mitmproxy || true

# convert certificate into format a wii u can use
RUN openssl x509 -in .mitmproxy/mitmproxy-ca-cert.pem -inform PEM -out .mitmproxy/mitmproxy-ca-cert.der -outform DER

# create folder with wii u certificates
RUN mkdir wii-u-certificates
RUN echo "Copy all the following files into the Wii U system store mlc01/sys/title/0005001b10054000/content/scerts/" > wii-u-certificates/README.txt
RUN cp .mitmproxy/mitmproxy-ca-cert.der wii-u-certificates/CACERT_NINTENDO_CA.der.proxy
RUN cp .mitmproxy/mitmproxy-ca-cert.der wii-u-certificates/CACERT_NINTENDO_CA_G2.der.proxy
RUN cp .mitmproxy/mitmproxy-ca-cert.der wii-u-certificates/CACERT_NINTENDO_CA_G3.der.proxy
RUN cp .mitmproxy/mitmproxy-ca-cert.der wii-u-certificates/CACERT_NINTENDO_CLASS2_CA.der.proxy
RUN cp .mitmproxy/mitmproxy-ca-cert.der wii-u-certificates/CACERT_NINTENDO_CLASS2_CA_G2.der.proxy
RUN cp .mitmproxy/mitmproxy-ca-cert.der wii-u-certificates/CACERT_NINTENDO_CLASS2_CA_G3.der.proxy

# install needed python packages
RUN pip install setuptools==76.0.0
RUN pip install requests
RUN pip install jsons

COPY . .

RUN pip install NintendoClients/

# set local IP of coredns/caddy/NEX servers
RUN sed -i "s/LOCAL_IP/$(ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p' | awk '{print $1}')/g" coredns/Corefile
RUN sed -i "s/LOCAL_IP/$(ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p' | awk '{print $1}')/g" caddy/Caddyfile
RUN sed -i "s/LOCAL_IP_UNIQUE_NAME/$(ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p' | awk '{print $1}')/g" NintendoClients/example_smm_server.py
RUN sed -i "s/LOCAL_IP_UNIQUE_NAME/$(ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p' | awk '{print $1}')/g" NintendoClients/example_friend_server.py

# start servers
COPY start.sh /start.sh
RUN chmod +x /start.sh
CMD ["bash", "start.sh"]
