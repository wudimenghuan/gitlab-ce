# GitLab 中文社区版

[![Build status](https://gitlab.com/gitlab-org/gitlab-ce/badges/master/build.svg)](https://gitlab.com/gitlab-org/gitlab-ce/commits/master)
[![Overall test coverage](https://gitlab.com/gitlab-org/gitlab-ce/badges/master/coverage.svg)](https://gitlab.com/gitlab-org/gitlab-ce/pipelines)
[![Code Climate](https://codeclimate.com/github/gitlabhq/gitlabhq.svg)](https://codeclimate.com/github/gitlabhq/gitlabhq)
[![Core Infrastructure Initiative Best Practices](https://bestpractices.coreinfrastructure.org/projects/42/badge)](https://bestpractices.coreinfrastructure.org/projects/42)
## 历史

本汉化项目继承自 [@larryli](https://gitlab.com/larryli) 发起的 [GitLab 中文社区版项目](https://gitlab.com/larryli/gitlab) （从 v7 ~ v8.8）。从 v8.9 之后，[@xhang](https://gitlab.com/xhang) 开始继续[本汉化项目](https://gitlab.com/xhang/gitlab)。

## 安装、汉化指南

> 基于 [Larry Li 版汉化指南](https://gitlab.com/larryli/gitlab/wikis/home) 修改

**(以 `9-0-stable-zh` 分支为例)**

### 直接使用[@twang2218](https://gitlab.com/twang2218) 打包好的 [Gitlab 中文版 Docker镜像](https://hub.docker.com/r/twang2218/gitlab-ce-zh/)

---

### 源码安装汉化

推荐按照 [gitlab-ce](https://gitlab.com/gitlab-org/gitlab-ce) 源代码中 [doc/install/installation.md](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/install/installation.md) 的内容手工安装 GitLab 中文版本。

相关修改只需要在 **Clone the Source** 步骤中使用 `https://gitlab.com/xhang/gitlab.git` 仓库和当前版本的后缀增加 `-zh` 即可。

另外也可以在 **Install Gems** 步骤中使用 `https://gems.ruby-china.org` 镜像加快 `gems` 安装。具体步骤如下：

```bash
cd /home/git/gitlab
sudo -u git -H bundle config mirror.https://rubygems.org https://gems.ruby-china.org

# 如果使用的是 PostgreSQL (注意，选项中包含 "without ... mysql")
sudo -u git -H bundle install --deployment --without development test mysql aws kerberos

# 或者如果你用的是 MySQL (注意，选项中包含 "without ... postgres")
sudo -u git -H bundle install --deployment --without development test postgres aws kerberos
```

对于升级操作也可以按照相应的 [update.md](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/update/README.md) 类似处理即可。

### Omnibus 安装汉化

#### 1. 使用 marbleqi 制作的[汉化增量补丁包](https://github.com/marbleqi/gitlab-ce-zh)

> 注： 使用该汉化补丁包需要重新配置编译资源文件

```bash
sudo gitlab-ctl reconfigure
```

---

#### 2. 手动导出汉化补丁包汉化

请先使用官方包安装或升级完成，确认当前版本。

```bash
sudo cat /opt/gitlab/embedded/service/gitlab-rails/VERSION

#获取当前版本
gitlab_version=$(sudo cat /opt/gitlab/embedded/service/gitlab-rails/VERSION)
```

假设当前版本为 `v9.0.0`，并确认汉化版本库是否包含该版本的汉化标签(`-zh`结尾)，也就是是否包含 `v9.0.0-zh`。

如果版本相同，首先在本地 `clone` 仓库。

```bash
# 克隆汉化版本库
git clone https://gitlab.com/xhang/gitlab.git
# 如果已经克隆过，则进行更新
git fetch
```

然后比较汉化标签和原标签，导出 patch 用的 diff 文件。

```bash
# 导出9.0.0 版本的汉化补丁
#git diff v9.0.0 v9.0.0-zh > ../9.0.0-zh.diff
#导出当前版本
git diff v${gitlab_version} v${gitlab_version}-zh > ../${gitlab_version}-zh.diff
```

然后上传 `9.0.0-zh.diff` 文件到服务器。


**注意：**
如果是老版本已汉化升级新版本后，重复汉化会100%失败。建议在升级后，先执行下面命令，删除汉化文件，然后再次汉化

```bash
sudo rm -rf /opt/gitlab/embedded/service/gitlab-rails/config/locales/*zh*
```

```
# 停止 gitlab
sudo gitlab-ctl stop
# 如果gitlab_version变量不存在，则默认取服务器gitlab当前版本
sudo patch -d /opt/gitlab/embedded/service/gitlab-rails -p1 < ${gitlab_version:=cat /opt/gitlab/embedded/service/gitlab-rails/VERSION}-zh.diff

```


确定没有 `.rej` 文件，重启 GitLab 即可。

```bash
sudo gitlab-ctl start
```

执行重新配置命令

```bash
sudo gitlab-ctl reconfigure
```

如果汉化中出现问题，请重新安装 GitLab（注意备份数据）。

## Test coverage

- [![Ruby coverage](https://gitlab.com/gitlab-org/gitlab-ce/badges/master/coverage.svg?job=coverage)](https://gitlab-org.gitlab.io/gitlab-ce/coverage-ruby) Ruby
- [![JavaScript coverage](https://gitlab.com/gitlab-org/gitlab-ce/badges/master/coverage.svg?job=rake+karma)](https://gitlab-org.gitlab.io/gitlab-ce/coverage-javascript) JavaScript

## Canonical source

The canonical source of GitLab Community Edition is [hosted on GitLab.com](https://gitlab.com/gitlab-org/gitlab-ce/).

## Open source software to collaborate on code

To see how GitLab looks please see the [features page on our website](https://about.gitlab.com/features/).

- Manage Git repositories with fine grained access controls that keep your code secure
- Perform code reviews and enhance collaboration with merge requests
- Complete continuous integration (CI) and CD pipelines to builds, test, and deploy your applications
- Each project can also have an issue tracker, issue board, and a wiki
- Used by more than 100,000 organizations, GitLab is the most popular solution to manage Git repositories on-premises
- Completely free and open source (MIT Expat license)

## Hiring

We're hiring developers, support people, and production engineers all the time, please see our [jobs page](https://about.gitlab.com/jobs/).

## Editions

There are two editions of GitLab:

- GitLab Community Edition (CE) is available freely under the MIT Expat license.
- GitLab Enterprise Edition (EE) includes [extra features](https://about.gitlab.com/products/#compare-options) that are more useful for organizations with more than 100 users. To use EE and get official support please [become a subscriber](https://about.gitlab.com/products/).

## Website

On [about.gitlab.com](https://about.gitlab.com/) you can find more information about:

- [Subscriptions](https://about.gitlab.com/pricing/)
- [Consultancy](https://about.gitlab.com/consultancy/)
- [Community](https://about.gitlab.com/community/)
- [Hosted GitLab.com](https://about.gitlab.com/gitlab-com/) use GitLab as a free service
- [GitLab Enterprise Edition](https://about.gitlab.com/features/#enterprise) with additional features aimed at larger organizations.
- [GitLab CI](https://about.gitlab.com/gitlab-ci/) a continuous integration (CI) server that is easy to integrate with GitLab.

## Requirements

Please see the [requirements documentation](doc/install/requirements.md) for system requirements and more information about the supported operating systems.

## Installation

The recommended way to install GitLab is with the [Omnibus packages](https://about.gitlab.com/downloads/) on our package server.
Compared to an installation from source, this is faster and less error prone.
Just select your operating system, download the respective package (Debian or RPM) and install it using the system's package manager.

There are various other options to install GitLab, please refer to the [installation page on the GitLab website](https://about.gitlab.com/installation/) for more information.

You can access a new installation with the login **`root`** and password **`5iveL!fe`**, after login you are required to set a unique password.

## Contributing

GitLab is an open source project and we are very happy to accept community contributions. Please refer to [CONTRIBUTING.md](/CONTRIBUTING.md) for details.

## Install a development environment

To work on GitLab itself, we recommend setting up your development environment with [the GitLab Development Kit](https://gitlab.com/gitlab-org/gitlab-development-kit).
If you do not use the GitLab Development Kit you need to install and setup all the dependencies yourself, this is a lot of work and error prone.
One small thing you also have to do when installing it yourself is to copy the example development unicorn configuration file:

    cp config/unicorn.rb.example.development config/unicorn.rb

Instructions on how to start GitLab and how to run the tests can be found in the [development section of the GitLab Development Kit](https://gitlab.com/gitlab-org/gitlab-development-kit#development).

## Software stack

GitLab is a Ruby on Rails application that runs on the following software:

- Ubuntu/Debian/CentOS/RHEL/OpenSUSE
- Ruby (MRI) 2.3
- Git 2.8.4+
- Redis 2.8+
- PostgreSQL (preferred) or MySQL

For more information please see the [architecture documentation](https://docs.gitlab.com/ce/development/architecture.html).

## UX design

Please adhere to the [UX Guide](doc/development/ux_guide/index.md) when creating designs and implementing code.

## Third-party applications

There are a lot of [third-party applications integrating with GitLab](https://about.gitlab.com/applications/). These include GUI Git clients, mobile applications and API wrappers for various languages.

## GitLab release cycle

For more information about the release process see the [release documentation](https://gitlab.com/gitlab-org/release-tools/blob/master/README.md).

## Upgrading

For upgrading information please see our [update page](https://about.gitlab.com/update/).

## Documentation

All documentation can be found on [docs.gitlab.com/ce/](https://docs.gitlab.com/ce/).

## Getting help

Please see [Getting help for GitLab](https://about.gitlab.com/getting-help/) on our website for the many options to get help.

## Is it any good?

[Yes](https://news.ycombinator.com/item?id=3067434)

## Is it awesome?

Thanks for [asking this question](https://twitter.com/supersloth/status/489462789384056832) Joshua.
[These people](https://twitter.com/gitlab/likes) seem to like it.
