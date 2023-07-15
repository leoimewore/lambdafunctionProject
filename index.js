import { EC2Client, StartInstancesCommand,StopInstancesCommand } from "@aws-sdk/client-ec2";
import { config } from "process";

const client= new EC2Client(config)


export const handler = async (event,_,callback) => {
const input ={
        InstanceIds: [
            event.instanceId
        ],
        region: "us-west-2"
    }
    let command;
    let rp3;
    
    //Declare response function
    let response = function(success,message){
        if (success){
            return {
                success: success, 
                body: message
            }
        }else{
            return message
        }
    };
    
    if (event.action === "START") {

        // Set ec2 instance with aws account region
        command = new StartInstancesCommand(input);
        try {
          const data = await client.send(command);
          // process data.
          return response(true,data)
        } catch (error) {
          // error handling.
          return response(false,error)
        }
    
        
}else if(event.action === "STOP"){
    command =new StopInstancesCommand(input)
    
    try {
          const data = await client.send(command);
          // process data.
          return response(true,data)
        } catch (error) {
          // error handling.
          return response(false,error)
        }
    
    
    
}else{
    
    
    return response(false, 'Action ['+event.action+'] not found! Please use START, STOP or SLACK as action');
}

};
