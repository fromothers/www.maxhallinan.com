const cssNano = require('cssnano');

module.exports = {
  plugins: [
    cssNano({
      preset: 'default',
    }),
  ]
};
