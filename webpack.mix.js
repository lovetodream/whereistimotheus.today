/* eslint-disable @typescript-eslint/no-var-requires, no-undef */
const mix = require("laravel-mix");
const LiveReloadPlugin = require("webpack-livereload-plugin");

mix.webpackConfig({
    plugins: [new LiveReloadPlugin()]
})
    .ts("Resources/Typescript/app.ts", "Public/js")
    .sass("Resources/Styles/app.scss", "Public/css")
    .options({
        processCssUrls: false,
        postCss: [require("tailwindcss")]
    })
    .sourceMaps(false);
