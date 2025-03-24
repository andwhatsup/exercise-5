// personal assistant agent 

/* Task 2 Start of your solution */

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }

/* 1. Print messages when beliefs about devices and owner are added or deleted */

@lights_added_plan
+lights(State)
    : true
    <-
         .print("Lights are now ", State);
    .

@lights_deleted_plan
-lights(State)
    : true
    <-
         .print("Lights belief removed: ", State);
    .

@blinds_added_plan
+blinds(State)
    : true
    <-
         .print("Blinds are now ", State);
    .

@blinds_deleted_plan
-blinds(State)
    : true
    <-
         .print("Blinds belief removed: ", State);
    .

@mattress_added_plan
+mattress(State)
    : true
    <-
         .print("Mattress is now ", State);
    .

@mattress_deleted_plan
-mattress(State)
    : true
    <-
         .print("Mattress belief removed: ", State);
    .

@owner_state_added_plan
+owner_state(State)
    : true
    <-
         .print("Owner is now ", State);
    .

@owner_state_deleted_plan
-owner_state(State)
    : true
    <-
         .print("Owner state belief removed: ", State);
    .

/* 2. React to an upcoming event: if the owner is awake, print a message;
   if asleep, start the wake-up routine */
@upcoming_event_now_awake_plan
+upcoming_event("now")
    : owner_state("awake")
    <-
         .print("Enjoy your event");
    .

@upcoming_event_now_asleep_plan
+upcoming_event("now")
    : owner_state("asleep")
    <-
         .print("Starting wake-up routine");
         !wake_up_user;
    .
/* 2. React to an upcoming event */
@upcoming_event_now_awake_plan
+upcoming_event("now")
    : owner_state("awake")
    <-
         .print("Enjoy your event");
    .

@upcoming_event_now_asleep_plan
+upcoming_event("now")
    : owner_state("asleep")
    <-
         .print("Starting wake-up routine");
         !wake_up_user;
    .

/* 3. Initial user wake-up preferences (lower rank means higher preference) */
+preference(artificial_light, 2).
+preference(natural_light, 1).
+preference(vibrations, 0).

/* (Optional inference rule version – not used in the following plans) */
best_option(Option) :-
    preference(Option, Rank)
    & not((preference(Other, OtherRank) & not(used_method(Other)) & OtherRank < Rank)).


/* 4. & 5. Plans to wake up the user, taking note of already used methods.
   The agent tries methods in order: vibrations → natural_light → artificial_light.
   It re-invokes the wake-up goal until the owner becomes awake.
*/

@wake_up_vibrations_plan
+!wake_up_user
    : owner_state("asleep") & not(used_method(vibrations))
    <-
         .print("Waking up user with mattress vibrations");
         setVibrationsMode;
         +used_method(vibrations);
         .wait(5000);
         !wake_up_user;
    .

@wake_up_natural_plan
+!wake_up_user
    : owner_state("asleep") & used_method(vibrations) & not(used_method(natural_light))
    <-
         .print("Waking up user with natural light");
         raiseBlinds;
         +used_method(natural_light);
         .wait(5000);
         !wake_up_user;
    .

@wake_up_artificial_plan
+!wake_up_user
    : owner_state("asleep") & used_method(vibrations) & used_method(natural_light) & not(used_method(artificial_light))
    <-
         .print("Waking up user with artificial light");
         turnOnLights;
         +used_method(artificial_light);
         .wait(5000);
         !wake_up_user;
    .

@wake_up_success_plan
+!wake_up_user
    : owner_state("awake")
    <-
         .print("User is now awake. Wake-up routine achieved.");
    .

/* Task 2 End of your solution */