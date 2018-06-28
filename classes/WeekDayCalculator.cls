public class WeekDayCalculator {
	
    //this class will convert a Date to a Day of the Week 
    //
    public static String calculateWeekDay(Date myDate){
        
        //creat a datetime from the date 
        Datetime myDateTime = DateTime.newInstance(myDate, Time.newInstance(0, 0, 0, 0));
        String dayOfWeek = myDateTime.format('EEEE');
        //System.debug(dayOfWeek);
        return dayOfWeek;
    }
}