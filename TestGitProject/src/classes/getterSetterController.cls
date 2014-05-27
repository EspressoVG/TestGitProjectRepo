public class getterSetterController {
    public string showString{
        get{
            system.debug('---I am in show String---');
            return showOtherGetter;
        }
        set;
    }
    
    public String showOtherGetter{
        get{
            string showOtherGetter = 'showingOtherGetter';
            return showOtherGetter;
        }
        set;
    }
}