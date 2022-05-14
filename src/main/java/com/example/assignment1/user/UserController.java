package com.example.assignment1.user;

import com.example.assignment1.connection.Database;
import com.example.assignment1.connection.UserData;
import com.example.assignment1.security.Security;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.sql.SQLException;
import java.util.Map;
/*test*/
@CrossOrigin
@RequestMapping("/api/user")
@RestController
public class UserController implements IUser {
    Database database = new UserData();
    Security security = new Security();
    @RequestMapping("register")
    @PostMapping
    @Override
    public ResponseEntity<Map<String, String>> register(@RequestBody String user) throws JSONException, SQLException, ClassNotFoundException{
        JSONObject userJson = new JSONObject(user);
        if(security.isValidUser(userJson).getStatusCode() == HttpStatus.OK)
            return database.create(userJson);
       else
           return security.isValidUser(userJson);
    }

    @RequestMapping("login")
    @PostMapping
    @Override
    public ResponseEntity<Map<String, String>> login(@RequestBody String credentials) throws JSONException, SQLException, ClassNotFoundException {
        JSONObject credentialsJson = new JSONObject(credentials);
        return database.getUser(credentialsJson);
    }

    @RequestMapping("updateProfile")
    @PostMapping
    @Override
    public ResponseEntity<Map<String, String>> updateProfile(@RequestBody String user) throws JSONException, SQLException, ClassNotFoundException {
        JSONObject userJson = new JSONObject(user);
        if(database.isUserExist(userJson).getStatusCode() == HttpStatus.OK) {
            if(security.isValidUser(userJson).getStatusCode() == HttpStatus.OK) {
                return database.update(userJson);
            }
            else
                return security.isValidUser(userJson);
        }
        else
            return database.isUserExist(userJson);
    }
}