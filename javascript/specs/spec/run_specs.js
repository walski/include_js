var jasmine = require('specs/lib/jasmine-1.0.2/jasmine').jasmine();

require('specs/spec/time_sheet_service_spec');

jasmine.getEnv().addReporter(new jasmine.TrivialReporter());
jasmine.getEnv().execute();