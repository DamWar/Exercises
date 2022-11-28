class Lasagna
{
    public int ExpectedMinutesInOven(){
        return 40;
    }

    public int RemainingMinutesInOven(int minutesInOven){
        return 40-minutesInOven;
    }

    public int PreparationTimeInMinutes(int nLayers){
        return 2*nLayers;
    }

    public int ElapsedTimeInMinutes(int nLayers, int minutesInOven){
        return 2*nLayers+minutesInOven;
    }
}