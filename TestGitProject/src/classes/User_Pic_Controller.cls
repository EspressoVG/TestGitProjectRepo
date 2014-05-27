public class User_Pic_Controller{
public string Photolink{get;set;}
    Public User_Pic_Controller()
    {
        User u = [Select u.SmallPhotoUrl, u.FullPhotoUrl From User u where u.id=:Userinfo.getUserid()];
        Photolink = u.FullPhotoUrl;
    }
}