let mix = require("laravel-mix");

mix.webpackConfig({
        plugins: [new LiveReloadPlugin()]
    })
    .sass("Resources/Styles/app.scss", "public/css")
    .options({
        processCssUrls: false,
        postCss: [require("tailwindcss")]
    })
    .sourceMaps(false);
