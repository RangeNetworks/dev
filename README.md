Development Environment
=========

A collection of tools to make working with the numerous software components as painless as possible.

If there's a task that annoys you when working with the code, open an issue to suggest an improvement. Or, better, send a pull request to get your automation included in the project.

### &#10143; [Get Started Here](https://github.com/RangeNetworks/dev/wiki)

#### Weather Report

| Component     | master status |
|---------------|:-------------:|
| asterisk | [![Build Status](https://travis-ci.org/RangeNetworks/asterisk.svg?branch=master)](https://travis-ci.org/RangeNetworks/asterisk) |
| asterisk-config | [![Build Status](https://travis-ci.org/RangeNetworks/asterisk-config.svg?branch=master)](https://travis-ci.org/RangeNetworks/asterisk-config) |
| liba53 | [![Build Status](https://travis-ci.org/RangeNetworks/liba53.svg?branch=master)](https://travis-ci.org/RangeNetworks/liba53) |
| libsqliteodbc | [![Build Status](https://travis-ci.org/RangeNetworks/libsqliteodbc.svg?branch=master)](https://travis-ci.org/RangeNetworks/libsqliteodbc) |
| libzmq | [![Build Status](https://travis-ci.org/RangeNetworks/libzmq.svg?branch=master)](https://travis-ci.org/RangeNetworks/libzmq) |
| smqueue | [![Build Status](https://travis-ci.org/RangeNetworks/smqueue.svg?branch=master)](https://travis-ci.org/RangeNetworks/smqueue) |
| subscriberRegistry | [![Build Status](https://travis-ci.org/RangeNetworks/subscriberRegistry.svg?branch=master)](https://travis-ci.org/RangeNetworks/subscriberRegistry) |
| system-config | [![Build Status](https://travis-ci.org/RangeNetworks/system-config.svg?branch=master)](https://travis-ci.org/RangeNetworks/system-config) |

#### Misc. Notes

- relink submodule branch tracking

```
$ vi .gitmodules
(change submodule to track different branch X)
$ git submodule update --init --remote
$ cd theSubmoduleDir
$ git checkout X
```
