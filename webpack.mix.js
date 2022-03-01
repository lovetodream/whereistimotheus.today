let mix = require("laravel-mix");

mix.js("Resources/Javascript/app.js", "public/js")
    .sass("Resources/Styles/app.scss", "public/css")
    .options({
        processCssUrls: false,
        postCss: [require("tailwindcss")]
    })
    .browserSync({
        proxy: "http://localhost:8080", 
        injectChanges: false
    });
