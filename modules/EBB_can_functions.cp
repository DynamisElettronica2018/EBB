#line 1 "C:/Users/sofia/Desktop/GIT REPO/EBB/modules/EBB_can_functions.c"



void CAN_routine()
{
 Can_resetWritePacket();
 Can_addIntToWritePacket(ebb_current_pos);
 Can_addIntToWritePacket(calibration_on_off);
 Can_addIntToWritePacket(error_flag);
 Can_write(EBB_BIAS_ID);
}
