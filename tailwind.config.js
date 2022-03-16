// eslint-disable-next-line @typescript-eslint/no-var-requires, no-undef
const plugin = require("tailwindcss/plugin");

// eslint-disable-next-line no-undef
module.exports = {
    mode: "jit",
    content: ["./Resources/Views/**/*.{leaf,html,js}"],
    theme: {
        extend: {},
    },
    plugins: [
        plugin(function ({ addVariant, e, postcss }) {
            addVariant("firefox", ({ container, separator }) => {
                const isFirefoxRule = postcss.atRule({
                    name: "-moz-document",
                    params: "url-prefix()",
                });
                isFirefoxRule.append(container.nodes);
                container.append(isFirefoxRule);
                isFirefoxRule.walkRules((rule) => {
                    rule.selector = `.${e(
                        `firefox${separator}${rule.selector.slice(1)}`
                    )}`;
                });
            });
        }),
    ],
};
