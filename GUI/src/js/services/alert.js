app.service('Alert', function () {

    this.alerts = [];

    this.addAlert = function(itype,iicon,imsg) {
        var exists = false;

        // check wether we have items, if we don't it can't exist.
        if(!(this.alerts.length > 0)){
            this.alerts.push({type: itype, icon: iicon, msg:imsg});
        }else{ // if we do have items check all of them
            for(var i = 0; i < this.alerts.length; i++){
                if(this.alerts[i].msg === imsg){
                    exists = true;
                    break;
                }
            }
            // if we aren't displaying the error yet, do so.
            if(!exists){
                this.alerts.push({type: itype, icon: iicon, msg:imsg});
            }
        }

        return;
    };

    this.closeAlert = function(index) {
       this.alerts.splice(index, 1);
    };
})