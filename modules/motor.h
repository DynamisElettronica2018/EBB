

typedef enum{
    EBB_OFF,
    EBB_START,
    EBB_MOVING,
    EBB_BRAKING;
    EBB_CENTRAL_CALIBRATION,
    EBB_ERROR,
    EBB_DRIVER_BRAKING
}ebb_states;

//Variables declaration
char blink_counter = 0;
char brake_counter = 0;


// functions declaration

void EBB_control(void);
void normal_motor_control(void);
void central_calibration_control(void);
void zero_position_control(void);
void motor_brake(void);

