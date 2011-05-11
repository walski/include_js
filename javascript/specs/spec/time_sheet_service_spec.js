var time_sheet_service = require('time_sheet_service');
var runner = require('specs/lib/jasmine-1.0.2/jasmine');

runner.describe("TimeSheetService module", function() {
  var time_logs;
  runner.beforeEach(function() {
    time_logs = [
      {employee: 'Susan',  project: 'Starlight', start: new Date(2011, 3, 28, 14, 30), end: new Date(2011, 3, 28, 16, 30)},
      {employee: 'George', project: 'Ventura',   start: new Date(2011, 3, 28, 11, 30), end: new Date(2011, 3, 28, 15, 15)},
      {employee: 'George', project: 'Ventura',   start: new Date(2011, 3, 28, 15, 30), end: new Date(2011, 3, 28, 19, 0)},
      {employee: 'Susan',  project: 'Ventura',   start: new Date(2011, 3, 28, 15, 30), end: new Date(2011, 3, 28, 19, 0)},
      {employee: 'Sergej', project: 'Starlight', start: new Date(2011, 3, 28, 17, 45), end: new Date(2011, 3, 29,  3, 0)}
    ];
  });
  
  runner.it("should be able to calculate the hours of given time_logs by employee", function() {
    var result = time_sheet_service.by_employee(time_logs);

    runner.expect(result).toEqual({
      'Susan': 5.5,
      'George': 7.25,
      'Sergej': 9.25
    });
  });

});