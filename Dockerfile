FROM alpine as builder
ARG TARGETPLATFORM

WORKDIR /

RUN --mount=target=/build tar xf /build/dist/tfa_*_$(echo ${TARGETPLATFORM} | tr '/' '_' | sed -e 's/arm_/arm/').tar.gz
RUN cp tfa /usr/bin/tfa

FROM gcr.io/distroless/static:nonroot
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /usr/bin/tfa /usr/bin/tfa
USER 65532:65532

CMD ["/usr/bin/tfa"]