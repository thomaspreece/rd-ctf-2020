FROM amd64/ubuntu

# RUN addgroup -S ctf && adduser -S ctf -G ctf
RUN addgroup ctf
RUN useradd --shell /bin/sh -g ctf -m ctf

WORKDIR /home/ctf

COPY --chown=root:ctf challenge /home/ctf/hurdles
RUN chmod 555 /home/ctf/hurdles

USER ctf

EXPOSE 8888

CMD ["/home/ctf/hurdles"]
