格式一: Oracle JDBC Thin using an SID:  
jdbc:oracle:thin:@host:port:SID  
Example: jdbc:oracle:thin:@localhost:1521:orcl  

格式二: Oracle JDBC Thin using a ServiceName:  
jdbc:oracle:thin:@//host:port/service_name  
Example:jdbc:oracle:thin:@//localhost:1521/orcl.city.com  

格式三：Oracle JDBC Thin using a TNSName:  
jdbc:oracle:thin:@TNSName  
Example: jdbc:oracle:thin:@TNS_ALIAS_NAME  

```
import java.sql.*;

public class TestOrclConnect {

	public static void main(String[] args) {
		ResultSet rs = null;
		Statement stmt = null;
		Connection conn = null;
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			 String dbURL =
			"jdbc:oracle:thin:@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521)))"
			+ "(CONNECT_DATA=(SERVICE_NAME=orcl.city.com)))";
			conn = DriverManager.getConnection(dbURL, "admin2", "123");
			System.out.println("连接成功");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) {
					rs.close();
					rs = null;
				}
				if (stmt != null) {
					stmt.close();
					stmt = null;
				}
				if (conn != null) {
					conn.close();
					conn = null;
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
}

```