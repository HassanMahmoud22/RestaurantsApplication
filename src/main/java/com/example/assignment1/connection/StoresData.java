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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class StoresData implements StoresDatabase {


    private void putStoreDataInMap(Map<String, String> data, ResultSet rs) throws SQLException {
        data.put(Keys.ID, rs.getString(Keys.ID));
        data.put(Keys.STORE, rs.getString(Keys.STORE));
        data.put(Keys.PHOTO, rs.getString(Keys.PHOTO));
        data.put(Keys.DESCRIPTION, rs.getString(Keys.DESCRIPTION));
        data.put(Keys.LATITUDE, rs.getString(Keys.LATITUDE));
        data.put(Keys.LONGITUDE, rs.getString(Keys.LONGITUDE));
    }

    private ResponseEntity<List<Map<String, String>>> getListResponseEntity(List<Map<String, String>> finalData, ResultSet rs) throws SQLException {
        while(rs.next())
        {
            Map<String, String> data = new HashMap<>();
            putStoreDataInMap(data, rs);
            finalData.add(data);
        }
        if(!finalData.isEmpty())
            return new ResponseEntity<>(finalData, HttpStatus.OK);
        return new ResponseEntity<>(finalData, HttpStatus.NOT_FOUND);
    }

    @Override
    public  ResponseEntity<List<Map<String, String>>> read() throws SQLException{

        List<Map<String, String>> finalData = new ArrayList<>();
        Statement statement = establishConnection().createStatement();
        ResultSet rs = statement.executeQuery("select * from stores");
        return getListResponseEntity(finalData, rs);
    }

    @Override
    public  ResponseEntity<List<Map<String, String>>> listAllFavorites(JSONObject user) throws SQLException{

        List<Map<String, String>> finalData = new ArrayList<>();
        Statement statement = establishConnection().createStatement();
        ResultSet rs = statement.executeQuery("SELECT stores.id, stores.storeName, stores.description, stores.photo, stores.latitude, stores.longitude\n" +
                "FROM stores \n" +
                "INNER JOIN favorites\n" +
                "INNER JOIN users\n" +
                "ON stores.id = favorites.storeId and users.id = favorites.userId\n" +
                "Where users.id = '" + user.getString(Keys.ID) + "';");
        return getListResponseEntity(finalData, rs);
    }

    @Override
    public ResponseEntity<Map<String, String>> addToFavorite(JSONObject user) throws SQLException {
        ResponseEntity favoriteResponse = isFavoriteExist(user);
        if(favoriteResponse.getStatusCode() == HttpStatus.NOT_FOUND) {
            Map<String, String> message = new HashMap<>();
            try {
                String query;
                PreparedStatement preparedStmt;
                query = "INSERT INTO favorites(userId, storeId) VALUES(?, ?) ";
                preparedStmt = establishConnection().prepareStatement(query);
                preparedStmt.setString(1, user.getString(Keys.USERID));
                preparedStmt.setString(2, user.getString(Keys.STOREID));
                preparedStmt.executeUpdate();
                establishConnection().close();
            } catch (SQLException e) {
                message.put(Keys.MESSAGE, Messages.IDSVALUES);
                return new ResponseEntity<>(message, HttpStatus.INTERNAL_SERVER_ERROR);
            } catch (JSONException e) {
                message.put(Keys.MESSAGE, Messages.JSONKEYSNOTVALID);
                return new ResponseEntity<>(message, HttpStatus.INTERNAL_SERVER_ERROR);
            }
            message.put(Keys.MESSAGE, Messages.FAVORITECREATED);
            return new ResponseEntity<>(message, HttpStatus.OK);
        }
        else
            return favoriteResponse;
    }

    @Override
    public ResponseEntity<Map<String, String>> getStore(JSONObject store) throws SQLException {
        Map<String,String> data = new HashMap<>();
        try{
            Statement statement = establishConnection().createStatement();
            ResultSet rs = statement.executeQuery("select * from stores where id ='"+ store.get(Keys.STOREID) + "'");
            if(rs.next())
            {
                putStoreDataInMap(data, rs);
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
    public ResponseEntity<Map<String, String>> isFavoriteExist(JSONObject favorite) {
        Map<String, String> message = new HashMap<>();
        try {
            Statement statement = establishConnection().createStatement();
            ResultSet rs = statement.executeQuery( "SELECT * FROM favorites WHERE userId = '" + favorite.getString(Keys.USERID) + "' and storeId = '" + favorite.getString(Keys.STOREID) + "'");
           if(rs.next()){
               message.put(Keys.MESSAGE, Messages.FAVORITEFOUND);
               return new ResponseEntity<>(message, HttpStatus.OK);
           }
           else {
               message.put(Keys.MESSAGE, Messages.FAVORITENOTFOUD);
               return new ResponseEntity<>(message, HttpStatus.NOT_FOUND);
           }
        }
        catch (SQLException e){
            message.put(Keys.MESSAGE, Messages.IDSVALUES);
            return new ResponseEntity<>(message, HttpStatus.INTERNAL_SERVER_ERROR);
        }
        catch (JSONException e){
            message.put(Keys.MESSAGE, Messages.JSONKEYSNOTVALID);
            return new ResponseEntity<>(message, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
