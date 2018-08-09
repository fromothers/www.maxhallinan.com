const cssNano = require('cssnano');
const easyImport = require('postcss-easy-import');

module.exports = {
  plugins: [
    easyImport,
    cssNano({
      preset: 'default',
    }),
  ]
};
