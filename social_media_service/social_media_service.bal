import ballerina/http;
import ballerina/time;

type User record {|
    readonly int id;
    string name;
    time:Date birthDate;
    string[] mobileNumbers; 
|};

table<User> key(id) users = table [
    {id: 1, name: "Joe", birthDate: {year:2003,month: 12,day:3}, mobileNumbers: ["1234567890", "0987654321"]}
];

type errorDetais record {
    string message;
    string details;
    time:Utc timeStamp;

};

type UserNotFoundError record {|
    *http:NotFound;
    errorDetais body;
|};



type NewUser record {
    string name;
    time:Date birthDate;
    string[] mobileNumbers;
};

service /social_media on new http:Listener(9090){

    // social-media/user
    resource function get users() returns User[]| error? {
        return users.toArray();
    }

    resource function get users/[int id] () returns User | UserNotFoundError|error{
        User? user = users[id];
        if user is () {
            UserNotFoundError userNotFound ={
                body: {message:string `id {$id}`, details: string `user/${id}`, timeStamp: time:utcNow()}
            };
            return userNotFound;
        }
        return user;
    }
       
    
    resource function post users(NewUser newUser) returns http:Created|error? {
        users.add({
            id: users.length() + 1,
            name: newUser.name,
            birthDate: newUser.birthDate,
            mobileNumbers: newUser.mobileNumbers
        });
        return http:CREATED;
       
    }
        


}
      
 