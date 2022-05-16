package com.example.assignment1.connection;

import com.example.assignment1.constants.Keys;
import com.example.assignment1.constants.Messages;
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

    @Override
    public ResponseEntity<Map<String, String>> create(JSONObject user) throws JSONException {
        Map<String, String> message = new HashMap<>();
        try{
            String query;
            PreparedStatement preparedStmt;
            if(user.getString(Keys.LEVEL).length() > 0){
                query = "INSERT INTO users(Name, Gender, Email, level, password) VALUES(?,?,?,?,?) ";
                preparedStmt = establishConnection().prepareStatement(query);
                preparedStmt.setString (1, user.getString(Keys.NAME));
                preparedStmt.setString (2, user.getString(Keys.GENDER));
                preparedStmt.setString (3, user.getString(Keys.EMAIL));
                preparedStmt.setInt (4, user.getInt(Keys.LEVEL));
                preparedStmt.setString (5, user.getString(Keys.PASSWORD));
            }
            else{
                query = "INSERT INTO users(Name, Gender, Email, password) VALUES(?,?,?,?) ";
                preparedStmt = establishConnection().prepareStatement(query);
                preparedStmt.setString (1, user.getString(Keys.NAME));
                preparedStmt.setString (2, user.getString(Keys.GENDER));
                preparedStmt.setString (3, user.getString(Keys.EMAIL));
                preparedStmt.setString (4, user.getString(Keys.PASSWORD));
            }
            preparedStmt.executeUpdate();
            establishConnection().close();
        }catch (SQLException e){
            message.put(Keys.MESSAGE, Messages.EMAILCONNECTED);
            return new ResponseEntity<>(message, HttpStatus.INTERNAL_SERVER_ERROR);
        }
        message.put(Keys.MESSAGE, Messages.ACCOUNTCREATED);
        return new ResponseEntity<>(message, HttpStatus.OK);
    }

    @Override
    public ResponseEntity<Map<String, String>> update(JSONObject user) {
        Map<String, String> message = new HashMap<>();
        try{
            String query = "UPDATE users SET name = ?, email = ?, password = ?, gender = ?, level = ? WHERE id = ?";
            PreparedStatement preparedStmt = establishConnection().prepareStatement(query);
            preparedStmt.setString(1, user.getString(Keys.NAME));
            preparedStmt.setString(2, user.getString(Keys.EMAIL));
            preparedStmt.setString(3, user.getString(Keys.PASSWORD));
            preparedStmt.setString(4, user.getString(Keys.GENDER));
            preparedStmt.setString(5, user.getString(Keys.LEVEL));
            preparedStmt.setString(6, user.getString(Keys.ID));
            preparedStmt.executeUpdate();
            establishConnection().close();
            message.put(Keys.MESSAGE, Messages.PROFILEUPDATED);
            return new ResponseEntity<>(message, HttpStatus.OK);
        }catch (SQLException e){
            message.put(Keys.MESSAGE, Messages.EMAILCONNECTED);
            return new ResponseEntity<>(message, HttpStatus.INTERNAL_SERVER_ERROR);
        }
        catch (JSONException e){
            message.put(Keys.MESSAGE, Messages.JSONKEYSNOTVALID);
            return new ResponseEntity<>(message, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    public  ResponseEntity<Map<String, String>> getIdByCredentials(JSONObject credentials) throws SQLException{
        Map<String,String> data = new HashMap<>();
        try{
            Statement statement = establishConnection().createStatement();
            ResultSet rs = statement.executeQuery("select * from users where email ='"+credentials.getString(Keys.EMAIL)+"' and password ='" + credentials.getString(Keys.PASSWORD) + "'");
            if(rs.next())
            {
                data.put(Keys.ID, rs.getString(Keys.ID));
                return new ResponseEntity<>(data, HttpStatus.OK);
            }
            else{
                return new ResponseEntity<>(data, HttpStatus.NOT_FOUND);
            }
        }
        catch (JSONException e){
            data.put(Keys.MESSAGE, Messages.JSONKEYSNOTVALID);
            return new ResponseEntity<>(data, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    public  ResponseEntity<Map<String, String>> read(JSONObject id) throws SQLException{
        Map<String,String> data = new HashMap<>();
        try{
            Statement statement = establishConnection().createStatement();
            ResultSet rs = statement.executeQuery("select * from users where id ='"+id.getString(Keys.ID)+"'");
            if(rs.next())
            {
                data.put(Keys.NAME, rs.getString(Keys.NAME));
                data.put(Keys.PASSWORD, rs.getString(Keys.PASSWORD));
                data.put(Keys.GENDER, rs.getString(Keys.GENDER));
                if(rs.getString(Keys.LEVEL) != null)
                    data.put(Keys.LEVEL, rs.getString(Keys.LEVEL));
                else
                    data.put(Keys.LEVEL, "");
                data.put(Keys.EMAIL, rs.getString(Keys.EMAIL));
                return new ResponseEntity<>(data, HttpStatus.OK);
            }
            else{
                data.put(Keys.MESSAGE, Messages.USERNOTEXIST);
                return new ResponseEntity<>(data, HttpStatus.NOT_FOUND);
            }
        }
        catch (JSONException e){
            data.put(Keys.MESSAGE, Messages.JSONKEYSNOTVALID);
            return new ResponseEntity<>(data, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    public ResponseEntity<Map<String, String>> isUserExist(JSONObject credentials) throws SQLException {
        Map<String, String> message = new HashMap<>();
        try {
            Statement statement = establishConnection().createStatement();
            ResultSet rs = statement.executeQuery("select * from users where email ='"+credentials.getString(Keys.EMAIL)+"' and password ='" + credentials.getString(Keys.PASSWORD) + "'");
            if (rs.next()) {
                message.put(Keys.MESSAGE, Messages.USEREXISTS);
                return new ResponseEntity<>(message, HttpStatus.OK);
            }
            message.put(Keys.MESSAGE, Messages.USERNOTEXIST);
            return new ResponseEntity<>(message, HttpStatus.NOT_FOUND);
        }
        catch (JSONException e){
            message.put(Keys.MESSAGE, Messages.JSONKEYSNOTVALID);
            return new ResponseEntity<>(message, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
