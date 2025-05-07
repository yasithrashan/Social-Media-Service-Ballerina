import ballerina/http;
import ballerina/time;

type User record {|
    int id;
    string name;
    time:Date birthDate;
    string[] mobileNumbers; // Corrected typo
|};

service /social_media on new http:Listener(9090){

    // social-media/user
    resource function get users() returns User[]| error? {
        User joe = {id: 1, name: "Joe", birthDate: {year:2003,month: 12,day:3}, mobileNumbers: ["1234567890", "0987654321"]};
        return [joe];
    }
}
 