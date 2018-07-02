
//functions

void CAN_routine()  //CAN update routine
{
    Can_resetWritePacket();  //Build the can packet -->
    Can_addIntToWritePacket(ebb_current_pos);
    Can_addIntToWritePacket(calibration_on_off);
    Can_addIntToWritePacket(error_flag);
    Can_write(EBB_BIAS_ID);  //Send the can packet
}