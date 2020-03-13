const { environment } = require('@rails/webpacker');
const webpack = require('webpack');
const handlebars = require('./loaders/handlebars');

environment.plugins.append(
    'Provide',
    new webpack.ProvidePlugin({
        $: "jquery",
        jQuery: 'jquery',
        "window.jQuery": "jquery",
        Popper: ['popper.js', 'default']
    }),
);

environment.loaders.prepend('handlebars', handlebars);
module.exports = environment;
