FROM golang:1.25-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY main.go ./
COPY hcloud/ hcloud/
COPY internal/ internal/
RUN CGO_ENABLED=0 go build -o hcloud-cloud-controller-manager .

FROM alpine:3.23
RUN apk add --no-cache ca-certificates bash
COPY --from=builder /app/hcloud-cloud-controller-manager /bin/hcloud-cloud-controller-manager
ENTRYPOINT ["/bin/hcloud-cloud-controller-manager"]
