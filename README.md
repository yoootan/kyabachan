
# Rails




# NuxtJS

NuxtJSは下記コマンドを用いて、プロジェクトを作成しています。

また、Railsとポート番号の衝突を回避するため、NuxtJSのサーバー使用ポート番号を3000番ポートから、
3100番ポートへ変更してます。(`package.json`で設定)

### 実行コマンド

```bash
$ yarn create nuxt-app kyabachan
$ mv kyabachan nuxtjs
```

### 作成ログ

```
yarn create v1.22.18
[1/4] 🔍  Resolving packages...
[2/4] 🚚  Fetching packages...
[3/4] 🔗  Linking dependencies...
[4/4] 🔨  Building fresh packages...
warning Your current version of Yarn is out of date. The latest version is "1.22.19", while you're on "1.22.18".
info To upgrade, run the following command:
$ curl --compressed -o- -L https://yarnpkg.com/install.sh | bash
success Installed "create-nuxt-app@4.0.0" with binaries:
      - create-nuxt-app

create-nuxt-app v4.0.0
✨  Generating Nuxt.js project in kyabachan
? Project name: kyabachan
? Programming language: TypeScript
? Package manager: Yarn
? UI framework: None
? Nuxt.js modules: (Press <space> to select, <a> to toggle all, <i> to invert selection)
? Linting tools: (Press <space> to select, <a> to toggle all, <i> to invert selection)
? Testing framework: None
? Rendering mode: Universal (SSR / SSG)
? Deployment target: Static (Static/Jamstack hosting)
? Development tools: jsconfig.json (Recommended for VS Code if you're not using typescript)
? What is your GitHub username? akkijp
? Version control system: Git

🎉  Successfully created project kyabachan

  To get started:

        cd kyabachan
        yarn dev

  To build & start for production:

        cd kyabachan
        yarn build
        yarn start


  For TypeScript users. 

  See : https://typescript.nuxtjs.org/cookbook/components/
✨  Done in 152.69s.
```
