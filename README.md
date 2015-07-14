# Altspace Programming Project - Rails HMD Tracker
## Joshua Angeley - jda5dp@virginia.edu

## Overview

- This rails app incorporates the AuditedState. When a Hmd state is 'updated', the app will add a new row to the Hmd_state table rather than update the Hmd state attribute.

- The state attribute in the Hmd table has been removed. Calling hmd.state now reflects the state value of the latest row inserted associated with the hmd.

- There are six tests written in hmd_test.rb. I followed the Test Driven Development methodology to develop the auditing feature. They were really useful when refactoring the code from the individual models to the ruby concern.

- This was the first time I have ever come across Ruby Metaprogramming, and while I've learned a lot, I was not able to implement it into this project. While the code has been refactored into audited_state.rb, the code remains tightly coupled, which means that the audit feature is not reusable. A pair programming session would be very helpful in developing this feature.

- My enhancement for this project is a small redesign of the app. I've imported Bootstrap, a popular HTML and CSS framework, and Bootswatch, and styled skin for Bootstrap, to help me out.

- This was also my first forway into HAML, although I have heard of it before this project. HAML is way cleaner than HTML

- I got rid of the table on the index.html, and put each hmd into their own card. Hover of the card to get a peak of the stats of the hmd, and click 'EDIT' to update the state of the hmd.

- The edit page of the hmd also does a good job of showing that the audit feature works correctly. Each state change that the hmd has gone through is listed.

## Technical Details

- The lastest official stable version of this application is held on the 'Official' git branch. The master branch is the forked branch that has not been updated at all. The 'AuditedState' branch is the development branch for the audit feature. The 'Design' branch is the development branch for the overall design feature. Make sure to checkout the Official branch to actually see the work done!

- I have written a migration script to transfer the hmd.state data from the hmd table to the hmd_state table. Unfortunately, this only works through very specific steps. Please read the instructions so that you can correctly set the database up correctly.

- I've been developing under the assumption that a newly created hmd will have "announced" by default. This has created a side effect of having Hmd.create() fail if the state is defined in the create method. For example, Hmd.create(state: "devkit") will fail because a new state will be appended to the hmd_state table before the hmd is created, which means the hmd.id would not be available yet.

## Instructions

# The Master Branch

- The master branch should have no changes. On the master branch, run rake db:reset to reset the database to the original configuration at the start of the project. If there are any errors in the database in the future, switch back to the master branch and run rake db:reset to return to the original configuration.

- rake db:reset first drops the database, then creates the database and then runs the migrations. There are only two migrations in the master branch, the first one creates the hmd table, and the second one creates the hmd_states table. Then, db:reset also calls db:seed, which then populates the hmd table with some data.

# The Migration Branch

- Once rake db:reset is ran on the master branch, run 'git checkout Migration'. The migration branch has one additional migration, which populates the hmd_state table and removes the state column in hmd table. To run this migration, run 'rake db:migrate'.

# The Official Branch

- Once rake db:migrate is ran on the Migration branch, run 'git checkout Official' to see the work done on both the audit feature and the design feature.

- Run 'rails s' to check out the work in the browser. You may have to run bundle install to install missing gems.

- The reason why you have to run these steps in this order is that the AuditedState has a state variable that attempts to create a hmd_state when it's assigned a value. This is good enough for editting an existing hmd, but when db:seed is called, the hmd_state create is called before the hmd is actually created, so we get a missing hmd_id error. Given more time I can come up with a fix, but I can not continue working on this project right now.

# If there are any questions, contact me at jda5dp@virginia.edu

## Screenshots

- In case there is something wrong with the project I don't know about

![Alt text](/images/Home_Page.png?raw=true "Home Page")

![Alt text](/images/OSVR_highlight.png?raw=true "OSVR Hover")

![Alt text](/images/Vive_Edit_Page.png?raw=true "Vive Edit Page")

![Alt text](/images/Vive_State_Update.png?raw=true "Vive State Update")

