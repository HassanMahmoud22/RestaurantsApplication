package com.example.assignment1.connection;

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;

public class UserData implements Database{
    private static final String ID = "id";
    private static final String NAME = "name";
    private static final String GENDER = "gender";
    private static final String EMAIL = "email";
    private static final String LEVEL = "level";
    private static final String PASSWORD = "password";
    private static final String MESSAGE = "message";
    private static final String EMAILCONNECTED = "This email is connected with other account";
    private static final String JSONKEYSNOTVALID = "Json keys aren't correct";

    @Override
    public ResponseEntity<Map<String, String>> create(JSONObject user) throws JSONException, ClassNotFoundException {
        Map<String, String> message = new HashMap<>();
        try{
            String query = "INSERT INTO users(Name, Gender, Email, level, password) VALUES(?,?,?,?,?) ";
            PreparedStatement preparedStmt = establishConnection().prepareStatement(query);
            preparedStmt.setString (1, user.getString(NAME));
            preparedStmt.setString (2, user.getString(GENDER));
            preparedStmt.setString (3, user.getString(EMAIL));
            preparedStmt.setInt (4, user.getInt(LEVEL));
            preparedStmt.setString (5, user.getString(PASSWORD));
            preparedStmt.executeUpdate();
            establishConnection().close();
        }catch (SQLException e){
            message.put(MESSAGE, EMAILCONNECTED);
            return new ResponseEntity<>(message, HttpStatus.INTERNAL_SERVER_ERROR);
        }
            message.put(MESSAGE,"The profile is updated Successfully");
            return new ResponseEntity<>(message, HttpStatus.OK);
    }

    @Override
    public ResponseEntity<Map<String, String>> update(JSONObject user) throws ClassNotFoundException {
        Map<String, String> message = new HashMap<>();
        try{
            String query = "UPDATE users SET name = ?, email = ?, password = ?, gender = ?, level = ? WHERE id = ?";
            PreparedStatement preparedStmt = establishConnection().prepareStatement(query);
            preparedStmt.setString(1, user.getString(NAME));
            preparedStmt.setString(2, user.getString(EMAIL));
            preparedStmt.setString(3, user.getString(PASSWORD));
            preparedStmt.setString(4, user.getString(GENDER));
            preparedStmt.setString(5, user.getString(LEVEL));
            preparedStmt.setString(6, user.getString(ID));
            preparedStmt.executeUpdate();
            establishConnection().close();
            message.put(MESSAGE,"The profile is updated Successfully");
            return new ResponseEntity<>(message, HttpStatus.OK);
        }catch (SQLException e){
            message.put(MESSAGE, EMAILCONNECTED);
            return new ResponseEntity<>(message, HttpStatus.INTERNAL_SERVER_ERROR);
        }
        catch (JSONException e){
            message.put(MESSAGE, JSONKEYSNOTVALID);
            return new ResponseEntity<>(message, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    public  ResponseEntity<Map<String, String>> getUser(JSONObject credentials) throws SQLException, ClassNotFoundException{
        Map<String,String> data = new HashMap<>();
        try{
            Statement statement = establishConnection().createStatement();
            ResultSet rs = statement.executeQuery("select * from users where email ='"+credentials.getString(EMAIL)+"' and password ='" + credentials.getString(PASSWORD) + "'");
            if(rs.next())
            {
                data.put(ID, rs.getString(ID));
                data.put(NAME, rs.getString(NAME));
                data.put(PASSWORD, rs.getString(PASSWORD));
                data.put(GENDER, rs.getString(GENDER));
                data.put(LEVEL, rs.getString(LEVEL));
                data.put(EMAIL, rs.getString(EMAIL));
                data.put(MESSAGE, "logged in successfully");
                return new ResponseEntity<>(data, HttpStatus.OK);
            }
            else{
                data.put(MESSAGE, "The Credentials are wrong");
                return new ResponseEntity<>(data, HttpStatus.NOT_FOUND);
            }
        }
        catch (JSONException e){
            data.put(MESSAGE, JSONKEYSNOTVALID);
            return new ResponseEntity<>(data, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    public ResponseEntity<Map<String, String>> isUserExist(JSONObject user) throws SQLException, ClassNotFoundException {
        Map<String, String> message = new HashMap<>();
        try {
            Statement statement = establishConnection().createStatement();
            ResultSet rs = statement.executeQuery("select * from users where id ='" + user.getString(ID) + "'");
            if (rs.next()) {
                message.put(MESSAGE, "User Exists");
                return new ResponseEntity<>(message, HttpStatus.OK);
            }
            message.put(MESSAGE, "User Doesn't Exist");
            return new ResponseEntity<>(message, HttpStatus.NOT_FOUND);
        }
        catch (JSONException e){
            message.put(MESSAGE, JSONKEYSNOTVALID);
            return new ResponseEntity<>(message, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}