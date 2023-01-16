# peacock-builder

Build script for a custom build of [The Peacock Project][1].

## What's different?

This build differs from the official builds in the following ways:

1. Supports HITMAN III Steam demo.
2. Bundles the [LocalGhost][2] patcher as an alternative to Peacock patcher.
3. Bundles the [Legacy Escalations Plugin][3] to be used out of the box.

## Installation

This repository includes a workflow for [GitHub Actions][4] which needs to be
run manually once set up. One can provide the following options before
triggering the workflow:

* The commit/tag to build Peacock at: Any tag or commit in
[thepeacockproject/Peacock][5].
* Don't bundle NodeJS: Enable to not include [NodeJS][6] in the build.

Once the build finishes, get the artifact from the **Artifacts** section of the
run and proceed for installation as listed in the [official website][7].

## Maintenance

Maintenance of this custom build involves managing patches rather than entire
codebase. Below are some naming conventions for these patches:

* Patches intended to be applied _forward_ are named `*.patch`.
* Patches intended to be applied _backward_ are named `*.revpatch`.
  * These patches should be [commits done in thepeacockproject/Peacock][8], and
  must be in `git am` format obtained by following [this][9] method.
  * In the instance the commit does not appear as an ancestor from which Peacock
  is being built, it will be ignored.
* Any other patches are ignored. For better clarity, append "`.ignore`" to the
file name.

Below patches provide this build of Peacock its own flavor:

* `steam-demo.patch`: Enables HITMAN III Steam demo support.
  * This still requires storefront authentication for access to content.
* `packaging.patch`: Enables the packaging process to include the
[LocalGhost][2] patcher and [Legacy Escalations Plugin][3], among other
improvements.

[1]: https://thepeacockproject.org
[2]: https://gitlab.com/grappigegovert/localghost
[3]: https://thepeacockproject.org/wiki/custom-content/#escalations
[4]: https://docs.github.com/en/actions
[5]: https://github.com/thepeacockproject/Peacock
[6]: https://nodejs.org
[7]: https://thepeacockproject.org/wiki/intel/installation
[8]: https://github.com/thepeacockproject/Peacock/commits
[9]: https://webapps.stackexchange.com/a/159720
