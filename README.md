doc.crds.dev warming action
=======================

This GitHub action is based on the great work of [Andrew Slotin](https://github.com/andrewslotin) and his [go-proxy-pull-action](https://github.com/andrewslotin/go-proxy-pull-action) action.

This action ensures that a newly released version of a custom resource is discovered by the [doc.crds.dev](https://doc.crds.dev) service.

Each time there is a new tag created in repository with a name that looks like a [semantic version](https://blog.golang.org/publishing-go-modules), the action will pull the new version of the custom resource module and request the [doc.crds.dev](https://doc.crds.dev) to warm up the cache for the new version.

Usage
-----

To renew the documentation on [doc.crds.dev](https://doc.crds.dev) create a new workflow file with following context:

```yaml
on:
  release:
    types:
      - created
    tags:
      - 'v[0-9]+.[0-9]+.[0-9]+'
      - '[0-9]+.[0-9]+.[0-9]+'

jobs:
  build:
    name: Renew documentation
    runs-on: ubuntu-latest
    steps:
    - name: Pull new module version
      uses: azrod/doc-crds-dev-update-action@master
```

This will trigger the action each time whenever a new release is published for a tag that looks either like `vX.Y.Z` or `X.Y.Z`.

### Custom import path

In case your module uses custom import path, such as `example.com/myproject`, an attempt to download it using its GitHub reporitory URL will result in an error. In this case you need to provide the import path of your package as an input:

```yaml
- name: Pull new module version
  uses: andrewslotin/go-proxy-pull-action@v1.1.0
  with:
      import_path: example.com/myproject
```

Why?
----

Although the `doc.crds.dev` are capable of pulling the missing versions on-demand, there are cases when
this needs to be done before anyone has requested a new version via a http request to the service.
An example would be updating the `doc.crds.dev` documentation of your library upon release.

License
-------

The scripts and documentation in this project are released under the [MIT License](LICENSE).
