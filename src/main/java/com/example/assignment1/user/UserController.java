package com.example.assignment1.user;

import com.example.assignment1.connection.Database;
import com.example.assignment1.connection.UserData;
import com.example.assignment1.security.JwtTokenUtil;
import com.example.assignment1.security.Validation;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.yaml.snakeyaml.events.Event;

import java.sql.SQLException;
import java.util.Map;

@CrossOrigin
@RequestMapping("/api/user")
@RestController
public class UserController implements IUser {
    Database database = new UserData();
    Validation validation = new Validation();
    JwtTokenUtil jwtTokenUtil = new JwtTokenUtil();
    @RequestMapping("register")
    @PostMapping
    @Override
    public ResponseEntity<Map<String, String>> register(@RequestBody String user) throws JSONException, SQLException, ClassNotFoundException{
        JSONObject userJson = new JSONObject(user);
        ResponseEntity<Map<String, String>> UserValidationResponse = validation.isValidUser(userJson);
        if(UserValidationResponse.getStatusCode() == HttpStatus.OK){
            ResponseEntity<Map<String, String>> signupResponse = database.create(userJson);
            if(signupResponse.getStatusCode() == HttpStatus.OK)
                signupResponse.getBody().put("token", jwtTokenUtil.generateToken(database.getIdByCredentials(userJson).getBody()));
            return signupResponse;
        }
       else
           return UserValidationResponse;
    }

    @RequestMapping("login")
    @PostMapping
    @Override
    public ResponseEntity<Map<String, String>> login(@RequestBody String credentials) throws JSONException, SQLException, ClassNotFoundException {
        JSONObject credentialsJson = new JSONObject(credentials);
        ResponseEntity<Map<String, String>> loginResponse = database.isUserExist(credentialsJson);
        if(loginResponse.getStatusCode() == HttpStatus.OK){
            loginResponse.getBody().put("message", "logged in successfully");
            loginResponse.getBody().put("token", jwtTokenUtil.generateToken(database.getIdByCredentials(credentialsJson).getBody()));
            return loginResponse;
        }
        loginResponse.getBody().put("message", "The Credentials are wrong");
        return loginResponse;
    }

    @RequestMapping("updateProfile")
    @PostMapping
    @Override
    public ResponseEntity<Map<String, String>> updateProfile(@RequestBody String user) throws JSONException, SQLException, ClassNotFoundException {
        JSONObject userJson = new JSONObject(user);
        if(validation.isValidUser(userJson).getStatusCode() == HttpStatus.OK){
            if(jwtTokenUtil.validateToken(userJson).getStatusCode() == HttpStatus.OK){
                    userJson.put("id", jwtTokenUtil.getIdFromToken(userJson).getString("id"));
                    return database.update(userJson);
            }
            return jwtTokenUtil.validateToken(userJson);
        }
        return validation.isValidUser(userJson);
    }

    @RequestMapping("getUser")
    @PostMapping
    @Override
    public ResponseEntity<Map<String, String>> getUser(@RequestBody String token) throws JSONException, SQLException, ClassNotFoundException {
        JSONObject tokenJson = new JSONObject(token);
        ResponseEntity validationResponse = jwtTokenUtil.validateToken(tokenJson);
        if (validationResponse.getStatusCode() == HttpStatus.OK) {
            JSONObject id = jwtTokenUtil.getIdFromToken(tokenJson);
            return database.read(id);
        }
        return validationResponse;
    }
}
