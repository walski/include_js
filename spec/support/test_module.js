exports.plus = function(a, b) {
  return a + b;
};

exports.minus = function(a, b) {
  return a - b;
};

var multiplier = require('test_sub_module');
exports.square = function(a) {
  return multiplier.multiply(a, a);
};