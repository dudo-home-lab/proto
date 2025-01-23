# Proto

## Usage

Added as a git submodule within downstream repos.

```sh
git submodule add https://github.com/gitops-ci-cd/proto.git ./proto
```

> [!IMPORTANT]
> When you change the state of a submodule (e.g., checking out a different tag), the main repository tracks this as a change to the submodule pointer (which is essentially a commit hash). You'll need to commit this change in the main repository.
>
> Always try to work with a specific tag:
>
> ```sh
> cd ./proto
> git fetch --tags
> git checkout tags/<tag-name>
> ```
>
> While this approach locks a submodule to a specific tag, it's important to note that working with branches and tags in submodules can lead to detached HEAD states. This is normal for submodules, as they are intended to point to a specific commit rather than being actively developed in the context of the main repository.

Code should be generated from the proto files in this repository. The generated code should be committed to the downstream repository. The downstream repository should have a protoc service within docker compose that generates the code. It's a bit language-specific, but here's an example for Go:

```yaml
protoc:
  image: protocolbuffers/protobuf:latest
  entrypoint: protoc
  command:
    - --proto_path=./proto
    - --go_opt=module=github.com/gitops-ci-cd/schema
    - --go_out=./internal/gen/pb
    - --go-grpc_opt=module=github.com/gitops-ci-cd/schema
    - --go-grpc_out=./internal/gen/pb
    - proto/**/*.proto
  volumes:
    - .:/usr/src/app:delegated
```
