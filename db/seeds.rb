# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Setup.create({:yearly_leaves => 21})
Role.create([{:name => "superadmin"}, {:name => "admin"}, {:name => "program_manager"}, {:name => "project_leader"},
{:name => "employee"}])
Designation.create([{:name => "Software Engineer"},{:name => "Test Engineer"}])
Technology.create([{name: 'Python'},{name: 'Java'},{name: 'Ruby'},{name: 'HTML'},{name: 'Javascript'},{name: 'C++'},
{name: 'C#'},{name: 'C#'},{name: 'PHP'},{name: 'SQL'},{name: 'Swift'},{name: 'IOS'},{name: 'Android'},{name: 'Kotlin'},
{name: 'Objective-C'},{name: 'Ruby on Rails'},{name: 'Django'},{name: 'Angular'},{name: 'ASP.net'},{name: 'Laravel'},
{name: 'Express'},{name: 'Spring'},{name: 'CodeIgniter'},{name: 'Spring boot'},{name: 'AWS'},{name: 'AWS Lambda'},
{name: 'AWS Cloudformation'}])
Status.create([{status:'In a meeting'}, {status:'Commuting'},{status:'Out sick'},{status:'Vacationing'},
{status:'Working remotely'}, {status:'Available'}, {status:'Unavailable'}])
DeviceType.create([{device_type:'Laptop'},{device_type:'Macbook'},{device_type:'iPad'},{device_type:'iPhone'},
{device_type:'Keyboard'},{device_type:'Monitor'},{device_type:'CPU'},{device_type:'Dongle'}])