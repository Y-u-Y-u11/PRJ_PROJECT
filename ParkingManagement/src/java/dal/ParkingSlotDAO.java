package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.ParkingSlot;

/**
 * Data Access Object for ParkingSlot.
 */
public class ParkingSlotDAO extends DBContext {

    private PreparedStatement stm;
    private ResultSet rs;

}
