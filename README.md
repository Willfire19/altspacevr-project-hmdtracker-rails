# Altspace Programming Project - Rails HMD Tracker
## Joshua Angeley

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

- You have asked for a migration script to move the legacy state column from the hmd table to the hmd_state table. I have not made that script yet, and that is the next step on the list. Initially, I thought calling 'rake db:reset' would correctly populate the hmd_state table because of the way the audit feature was built. This is the audited_state.rb here:
```
module AuditedState
  extend ActiveSupport::Concern

  included do
    after_create :create_new_state

    has_many :hmd_states
  end

  def state=(new_state)
    
    if new_state != "announced" and new_state != "devkit" and new_state != "released"
      raise "Validation Error: #{new_state} is not a valid state"
    else
      @new_hmd_state = self.hmd_states.build( state: new_state )
      @new_hmd_state.save
      @state = @new_hmd_state.state
    end

  end

  def state
    @state
  end

  private

    def create_new_state
      self.state = "announced"
    end

end
```
db:reset calls db:drop (which drops the entire database), then calls db:setup, which creates the database, runs all the migrations, then calls db:seed. When db:seed is called, it creates a hmd for each listing in seeds.rb. When an hmd is created, the create_new_state method is called, which then calls state=(new_state) with new_state being equal to "announced". So every hmd's state is "announced" by default.

- I've been developing under the assumption that a newly created hmd will have "announced" by default. This has created a side effect of having Hmd.create() fail if the state is defined in the create method. For example, Hmd.create(state: "devkit") will fail because a new state will be appended to the hmd_state table before the hmd is created, which means the hmd.id would not be available yet.

## Instructions

Update an existing Rails project to audit changes to a state table, and then include additional enhancements of your own.

## Goals

We use this test to get a sense of your coding style, your Ruby skills, and to how you creatively solve both a concrete problem and an abstract one. When we receive your project, here is what we will be asking ourselves:

- Does the basic functionality of the app work as intended?

- Is the auditing extension (described in Part 1 below) implemented properly?

- Do the enhancements (from Part 2) work well?

- Are the enhancements creative, challenging to implement, and just plain cool?

- Is the code well structured, easy to read and understand, and organized well?

This project should take approximately 5-15 hours to complete.

- Fork and clone the repo.

- Inside of the `hmdtrack` folder you'll find a simple rails app you'll be modifying that lets you see a list of upcoming VR HMDs, and edit the state they are in. You'll need to run both `db:migrate` and `db:seed` to populate the initial db.  

# Part 1 - Audited State Transitions (3-5 hours)

At AltspaceVR, we implement a number of patterns in our Rails stack which are designed to improve auditing and reduce the amount of mutable state in our system. As a general rule, we always perform `INSERTs` and never `UPDATEs` or `DELETEs` in our database. We've added facilities to Rails to let programmers use ActiveRecord models as always, but under the hood tables are appended to not overwritten. You'll be implementing a variant of one of these patterns here.

In this small Rails app, we have a simple `hmds` table which includes all of the information about a small set of VR HMDs. Currently, the table looks like this:

```
+---------------------------------------------------
 id           | integer                     | not null default 
 name         | character varying(512)      | not null
 company      | character varying(512)      | not null
 state        | character varying(64)       | not null
 image_url    | character varying(512)      | not null
 announced_at | timestamp without time zone | not null
 created_at   | timestamp without time zone | not null
 updated_at   | timestamp without time zone | not null

```
(This is from PostgreSQL, you can use MySQL with this project as well.)

If you hit the app, you'll be presented with a list of HMDs and the state they are in. You can click the `Edit` link to update the state. Here's how this is done in the `hmds_controller.rb`:

```
  def update
    @hmd = Hmd.find(params[:id])
    @hmd.state = params[:hmd][:state]
    @hmd.save!

    redirect_to hmds_path
  end
```

As you can see, the state is updated directly on the table via an `UPDATE` statement to the database.

For this project, we would like you to change the way this state is stored. Instead of storing it on the table directly where it is continually overwritten, it will be stored in a secondary table that will continually have new rows appended whenever the state changes. This ensures that we can have a record of how the state changes over time. This second, initially empty table in the database is called `hmd_states`:

```
+---------------------------------------------------------
 id         | integer                     | not null default 
 hmd_id     | integer                     | not null
 state      | character varying(64)       | not null
 created_at | timestamp without time zone | not null
 updated_at | timestamp without time zone | not null

```

What we're looking for is a small bit of reusable Rails code which will result in the `state` attribute on the main model (in this case, `Hmd`) reflecting the value of the `state` column of the latest row inserted into this table for that record. Setting the `state` attribute should also result in an insert into this table.

We would like this to be factored in a way to be re-usable. Your final implementations of the two models, `Hmd` and `HmdState` should look like this:

`hmd.rb`:
```
class Hmd < ActiveRecord::Base
  include AuditedState
  
  has_audited_state_through :hmd_states, [:announced, :devkit, :released]
end
```

`hmd_state.rb`
```
class HmdState < ActiveRecord::Base
  include AuditedState
  
  is_audited_state_for :hmd
end
```

This shows how you should be able to wire these two classes together. The `Hmd` class specifies which model to track the `state` attribute through via `has_audited_state_through`, and also specifies what are valid values for the state. Additionally, `HmdState` wires itself in the other direction via `is_audited_state_for`.

You can implement `AuditedState` as a Rails [Concern](http://api.rubyonrails.org/classes/ActiveSupport/Concern.html) and should use Ruby metaprogramming to extend the class's functionality. Here are the requirements for this concern:

- `model.state` should initially equal the first valid value (in this example, `:announced`), even if there are no rows in the state table for that model yet.

- `model.state = :new_state` should insert a row into the state table with the value `new_state` in the database, and subsequent calls to `model.state` should return `:new_state`.

- You can set `model.state` to a string or a symbol, and it should work. Reading `model.state` should return a symbol.

- Trying to update `model.state` to an invalid value should raise a validation exception.

You should **not** need to change the controller code if you've implemented this correctly. By simply making these changes to the two model classes to include and use `AuditedState` you should be seeing rows get inserted into the `hmd_states` table instead of updating the `state` column on the `hmds` table.

For this part of the project, there are a few things we'll be looking for in your submitted repo:

- Your implementation of `audited_state.rb`
- A small set of unit tests + test fixtures.
- A migration script to migrate the existing legacy `state` column value into the new `hmd_states` table, and removal of the legacy column.

For this part of the project, please **do not** include additional 3rd party code. You can reference 3rd party code of course, but any code you write for the concern should be your own. (We'll be asking you how it works!)

# Part 2 - HMD Tracker Enhancements (5-10 hours)

The included app is pretty basic. This second part of the project is more open ended: we'd like you to spend time improving the functionality of the app in a way that showcases your skills and creativity. This is your chance to blow us away!

Some ideas:

- Improve the state auditing library with better efficiency or more features.
- Update the app to have a more responsive, AJAX-y UX.
- Add a basic authentication system and a way for users to customize the list.
- Implement some type of notifications when something changes.
- Anything you want! Been wanting to play with some new Ruby or JS framework? Use this as an excuse!

Feel free to use 3rd party code (gems, libraries) as needed, keeping in mind our assessment criteria (noted at the top of the README.)

## Deliverable

In your repo, you should clobber this README file with your own describing your project. Any instructions or known issues should be documented in the README as well.

E-mail us a link to your Github repo to `projects@altvr.com`. Please include your contact information, and if you haven't submitted it to us already, your resume and cover letter. 

We hope you have fun working on the project, and we can't wait to see what you come up with!
    
[The Altspace Team](http://altvr.com/team/)


