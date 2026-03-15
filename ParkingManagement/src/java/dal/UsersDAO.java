package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.Users;

/**
 * Data Access Object for Users.
 */
public class UsersDAO extends DBContext {
    private PreparedStatement stm;
    private ResultSet rs;

}
