var hours_between = function(start, end) {
  return ((end - start) / 1000) / (3600);
};

exports.by_employee = function(time_logs) {
  var result = {};
  for (var i = time_logs.length - 1; i >= 0; i--){
    var log = time_logs[i];
    if (!result[log.employee]) {
      result[log.employee] = 0;
    }
    result[log.employee] += hours_between(log.start, log.end);
  }
  
  return result;
};