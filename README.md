# peacock-builder

Build script for a custom build of [The Peacock Project][1].

## What's different?

Refer to the [patches list][2] to view the differences.

## Installation

This repository includes a workflow for [GitHub Actions][4] which needs to be
run manually once set up. The action requires the following parameters:

* The commit/tag to build Peacock from: Any tag or commit in
[thepeacockproject/Peacock][5].
* The platform to build Peacock for: Any, or linux(doesn't include [NodeJS][6])
version.

Once the build finishes, get the artifact from the **Artifacts** section of the
run and proceed for installation as listed in the [official website][7].

## Maintenance

Maintenance of this custom build involves managing patches stored in the
`patches` directory rather than entire codebase. Below are some naming
conventions for these patches:

* Patches intended to be applied _as is_ are named `*.patch`.
* Patches intended to be applied _reversed_ are named `*.revpatch`.
  * These patches should be [commits done in thepeacockproject/Peacock][8], and
  must be in `git am` format obtained by [following this method][9].
  * In the instance the commit does not appear as an ancestor from which Peacock
  is being built, it will be ignored.
* Any other patches are ignored. For better clarity, append "`.ignore`" to the
file name.

### Patches included

By default, the following patches are applied during build:

* `steam-demo.patch`: Enables support for HITMAN World of Assassination Steam
  demo(Steam authentication required for access to content).
* `packaging.patch`: Modifies the packaging process for proper artifact upload
  in GitHub actions.
* `default-flags.patch`: Changes some default configuration flags out of the
  box.
* `dashboard-go-to-evergreen-planning.patch`: Makes the Freelancer tile in the
  main menu take to the planning screen instead of [taking in-game][11].
* `disable-mission-rewards.patch`: Disables post-mission rewards screen when
  `enableMasteryProgression` is set `false`.
* `unlock-order-for-planning-sort.patch`: Correctly sorts entrances and
  stashpoints which don't unlock through mastery.
* `disable-roadmap-modal.patch`: Disables roadmap popup on first boot, also
  doesn't popup when switching back to official servers.
* `remove-store-tab.patch`: Removes the store tab from the main menu.

[1]: https://thepeacockproject.org
[2]: https://github.com/royarg02/peacock-builder#patches-included
[4]: https://docs.github.com/en/actions
[5]: https://github.com/thepeacockproject/Peacock
[6]: https://nodejs.org
[7]: https://thepeacockproject.org/wiki/intel/installation
[8]: https://github.com/thepeacockproject/Peacock/commits
[9]: https://webapps.stackexchange.com/a/159720
[11]: https://en.wikipedia.org/wiki/Principle_of_least_astonishment
