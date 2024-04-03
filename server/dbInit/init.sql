--- Create a table for the database

-- This table will be moved to firebase
CREATE TABLE accounts
(
    id SERIAL PRIMARY KEY,
    account_username VARCHAR(50) NOT NULL,
    account_password  VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(11) NOT NULL
);
-- this will not reference anything 
CREATE TABLE fafsas
(
    id SERIAL PRIMARY KEY,
    account_id INT NOT NULL REFERENCES accounts ON DELETE CASCADE,
    needs_css BOOLEAN NOT NULL,
    confirmation_msg TEXT,
    academic_year DATE NOT NULL CHECK (academic_year <= CURRENT_DATE + 365),
    is_deleted BOOLEAN NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE user_types
(
    id SERIAL PRIMARY KEY,
    user_type VARCHAR(20) NOT NULL UNIQUE CHECK (user_type IN ('student', 'custodial', 'noncustodial'))
);
CREATE TABLE users
(
    id SERIAL PRIMARY KEY,
    fafsa_id INT NOT NULL REFERENCES fafsas ON DELETE CASCADE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL CHECK (date_of_birth <= CURRENT_DATE),
    user_types_id INT NOT NULL REFERENCES user_types ON DELETE RESTRICT
);
CREATE TABLE schools
(
    school_id SERIAL PRIMARY KEY,
    school_name VARCHAR(100)
);
CREATE TABLE housing_plans
(
    id SERIAL PRIMARY KEY,
    housing_plan VARCHAR(15) NOT NULL UNIQUE CHECK (housing_plan IN ('on campus', 'off campus', 'with parents'))
);
CREATE TABLE application_types
(
    id SERIAL PRIMARY KEY,
    application_type VARCHAR(50) NOT NULL UNIQUE CHECK (application_type IN ('regular decision','early decision', 'early action'))
);
CREATE TABLE users_schools
(
    user_id INT NOT NULL REFERENCES users ON DELETE CASCADE,
    school_id INT NOT NULL REFERENCES schools ON DELETE RESTRICT,
    housing_plan_id INT REFERENCES housing_plans ON DELETE RESTRICT,
    application_type_id INT REFERENCES application_types ON DELETE RESTRICT,
    PRIMARY KEY (user_id, school_id)
);
CREATE TABLE marital_statuses (
    id SERIAL PRIMARY KEY,
    marital_status VARCHAR(20) NOT NULL UNIQUE CHECK (marital_status IN ('never married', 'married', 'divorced','widowed'))
);
CREATE TABLE high_school_statuses
(
    id SERIAL PRIMARY KEY,
    high_school_status VARCHAR(20) NOT NULL UNIQUE CHECK (high_school_status IN ('diploma', 'ged', 'home schooled','none'))
);
CREATE TABLE fafsaStudentDetails
(
    user_id INT PRIMARY KEY REFERENCES users ON DELETE CASCADE,
    social_security VARCHAR(10) NOT NULL,
    phone VARCHAR(11) NOT NULL,
    email VARCHAR(100) NOT NULL,
    fafsa_username VARCHAR(50) NOT NULL,
    fafsa_password VARCHAR(50) NOT NULL,
    legal_residence_date DATE NOT NULL CHECK (legal_residence_date <= CURRENT_DATE),
    citizen_status VARCHAR(20) NOT NULL,
    alien_number VARCHAR(20),
    marital_status_id INT NOT NULL REFERENCES marital_statuses ON DELETE RESTRICT,
    high_school_status_id INT NOT NULL REFERENCES high_school_statuses ON DELETE RESTRICT,
    high_school_name VARCHAR(50),
    high_school_city VARCHAR(50) NOT NULL,
    high_school_state VARCHAR(50) NOT NULL,
    grade_level VARCHAR(20) NOT NULL,
    is_active_duty BOOLEAN NOT NULL,
    is_veteran BOOLEAN NOT NULL,
    has_children BOOLEAN NOT NULL,
    has_dependents BOOLEAN NOT NULL,
    was_orphan BOOLEAN NOT NULL,
    was_foster_care BOOLEAN NOT NULL,
    was_emancipated_minor BOOLEAN NOT NULL,
    was_homeless BOOLEAN NOT NULL
);
CREATE TABLE addresses
(
    id SERIAL PRIMARY KEY,
    street_address VARCHAR(100) NOT NULL,
    unit VARCHAR(20),
    city VARCHAR(50) NOT NULL,
    address_state VARCHAR(50),
    zip VARCHAR(20)
);
-- if user is deleted, manually delete address
CREATE TABLE users_addresses
(
    user_id INT NOT NULL REFERENCES users,
    address_id INT NOT NULL REFERENCES addresses ON DELETE CASCADE,
    PRIMARY KEY (user_id, address_id)
);
CREATE TABLE assets
(
    user_id INT PRIMARY KEY REFERENCES users ON DELETE CASCADE,
    cash INT NOT NULL CHECK (cash >= 0),
    passbook_savings INT NOT NULL CHECK (passbook_savings >= 0),
    certificate_of_deposit INT NOT NULL CHECK (certificate_of_deposit >= 0),
    t_bills INT NOT NULL CHECK (t_bills >= 0),
    money_market_funds INT NOT NULL CHECK (money_market_funds >= 0),
    stocks INT NOT NULL CHECK (stocks >= 0),
    bonds INT NOT NULL CHECK (bonds >= 0),
    tax_exempt_bonds INT NOT NULL CHECK (tax_exempt_bonds >= 0),
    custodial_accounts INT NOT NULL CHECK (custodial_accounts >= 0), 
    trust_funds INT NOT NULL CHECK (trust_funds >= 0),
    pre_paid_college_plan INT NOT NULL CHECK (pre_paid_college_plan >= 0),
    limited_partnership INT NOT NULL CHECK (limited_partnership >= 0),
    farm_net_worth INT NOT NULL CHECK (farm_net_worth >= 0),
    real_estate_net_worth INT NOT NULL CHECK (real_estate_net_worth >= 0),
    business_net_worth INT NOT NULL CHECK (business_net_worth >= 0)
);
CREATE TABLE realEstate
(
    user_id INT PRIMARY KEY REFERENCES users ON DELETE CASCADE,
    street_address VARCHAR(100) NOT NULL,
    unit VARCHAR(20),
    city VARCHAR(50) NOT NULL,
    address_state VARCHAR(50),
    zip VARCHAR(20),
    current_market_value INT NOT NULL CHECK (current_market_value >= 0),
    amount_owed INT NOT NULL CHECK (amount_owed >= 0),
    months_rented SMALLINT NOT NULL CHECK (months_rented >= 0),
    purchase_year DATE NOT NULL CHECK (purchase_year <=  CURRENT_DATE),
    purchase_price INT NOT NULL CHECK (purchase_price >= 0)
);
CREATE TABLE budgets
(
    user_id INT PRIMARY KEY REFERENCES users ON DELETE CASCADE,
    monthly_529_contribution INT NOT NULL,
    pledged_money INT NOT NULL CHECK (pledged_money >= 0),
    monthly_cash_flow INT NOT NULL CHECK (monthly_cash_flow >= 0),
    other_help INT NOT NULL CHECK (other_help >= 0)
);
CREATE TABLE relationships_to_student
(
    id SERIAL PRIMARY KEY,
    relationship_to_student VARCHAR(50) NOT NULL UNIQUE CHECK (relationship_to_student IN ('mother','father', 'step mother','step father', 'sibling','stepsibling','spouse','child','grandparent','other'))
);
CREATE TABLE highest_education_levels
(
    id SERIAL PRIMARY KEY,
    highest_education_level VARCHAR(50) NOT NULL UNIQUE CHECK (highest_education_level IN ('middle school', 'high school', 'college','unknown'))
);
CREATE TABLE fafsaParentDetails
(
    user_id INT PRIMARY KEY REFERENCES users ON DELETE CASCADE,
    relationship_to_student_id INT REFERENCES relationships_to_student ON DELETE RESTRICT,
    social_security VARCHAR(10) NOT NULL,
    phone VARCHAR(11) NOT NULL,
    email VARCHAR(100) NOT NULL,
    fafsa_username VARCHAR(50),
    fafsa_password VARCHAR(50),
    legal_residence_date DATE NOT NULL CHECK (legal_residence_date <= CURRENT_DATE),
    highest_education_id INT NOT NULL REFERENCES highest_education_levels ON DELETE RESTRICT,
    is_veteran BOOLEAN NOT NULL,
    is_dislocated_worker BOOLEAN NOT NULL,
    is_deceased BOOLEAN NOT NULL,
    is_custodial BOOLEAN NOT NULL,
    marital_status_id INT NOT NULL REFERENCES marital_statuses ON DELETE RESTRICT,
    individual_earnings INT CHECK (individual_earnings >= 0),
    point_of_contact BOOLEAN NOT NULL,
    employment_status VARCHAR(20) NOT NULL,
    job_title VARCHAR(20) NOT NULL,
    company VARCHAR(20) NOT NULL,
    years_worked SMALLINT NOT NULL CHECK (years_worked >= 0),
    number_of_dependents SMALLINT NOT NULL CHECK (number_of_dependents >= 0)
);
CREATE TABLE cssStudentDetails
(
    user_id INT PRIMARY KEY REFERENCES users ON DELETE CASCADE,
    css_username VARCHAR(50) NOT NULL,
    css_password VARCHAR(50) NOT NULL,
    housing_plans VARCHAR(50) NOT NULL,
    expected_summer_earnings_year1 INT NOT NULL CHECK (expected_summer_earnings_year1 >= 0),
    expected_summer_earnings_year2 INT NOT NULL CHECK (expected_summer_earnings_year2 >= 0),
    expected_school_earnings_year1 INT NOT NULL CHECK (expected_school_earnings_year1 >= 0),
    expected_school_earnings_year2 INT NOT NULL CHECK (expected_school_earnings_year2 >= 0),
    expected_from_parents INT NOT NULL CHECK (expected_from_parents >= 0),
    expected_from_gift_aid INT NOT NULL CHECK (expected_from_gift_aid >= 0),
    expected_from_employees INT NOT NULL CHECK (expected_from_employees >= 0)
);
CREATE TABLE cssParentDetails
(
    user_id INT PRIMARY KEY REFERENCES users ON DELETE CASCADE,
    retirement_contribution INT NOT NULL CHECK (retirement_contribution >= 0),
    hsa_contribution INT NOT NULL CHECK (hsa_contribution >= 0),
    fsa_medical_contribution INT NOT NULL CHECK (fsa_medical_contribution >= 0),
    fsa_dependent_contribution INT NOT NULL CHECK (fsa_dependent_contribution >= 0),
    social_security_benefits INT NOT NULL CHECK (social_security_benefits >= 0),
    alimony_received INT NOT NULL CHECK (alimony_received >= 0),
    expected_earnings_work INT NOT NULL CHECK (expected_earnings_work >= 0),
    expected_earnings_other INT NOT NULL CHECK (expected_earnings_other >= 0),
    work_income_change INT CHECK (work_income_change >= 0),
    other_income_change INT CHECK (other_income_change >= 0),
    year_of_separation DATE CHECK (year_of_separation > '1950-01-01'),
    year_of_divorce DATE CHECK (year_of_divorce > '1950-01-01'),
    expected_other_parent_contribution INT CHECK (expected_other_parent_contribution >= 0),
    contribution_written_agreement BOOLEAN,
    total_child_support_received INT CHECK (total_child_support_received >= 0),
    child_support_paid_year1 INT CHECK (child_support_paid_year1 >= 0),
    child_support_to_student_year1 INT CHECK (child_support_to_student_year1 >= 0),
    child_support_paid_year2 INT CHECK (child_support_paid_year2 >= 0),
    child_support_to_student_year2 INT CHECK (child_support_to_student_year2 >= 0),
    medical_expense_amount INT CHECK (medical_expense_amount >= 0),
    expected_medical_expenses INT CHECK (expected_medical_expenses >= 0),
    college_debt_amount_year1 INT NOT NULL CHECK (college_debt_amount_year1 >= 0),
    college_debt_amount_year2 INT NOT NULL CHECK (college_debt_amount_year2 >= 0),
    alimony_paid_year1 INT CHECK (alimony_paid_year1 >= 0),
    alimony_paid_year2 INT CHECK (alimony_paid_year2 >= 0)
);
CREATE TABLE governmentAssistance
(
    user_id INT PRIMARY KEY REFERENCES users ON DELETE CASCADE,
    earned_income_credit_year1 BOOLEAN NOT NULL,
    earned_income_credit_year2 BOOLEAN NOT NULL,
    federal_housing_assistance_year1 BOOLEAN NOT NULL,
    federal_housing_assistance_year2 BOOLEAN NOT NULL,
    free_lunch_year1 BOOLEAN NOT NULL,
    free_lunch_year2 BOOLEAN NOT NULL,
    medicaid_year1 BOOLEAN NOT NULL,
    medicaid_year2 BOOLEAN NOT NULL,
    qualified_health_plan_year1 BOOLEAN NOT NULL,
    qualified_health_plan_year2 BOOLEAN NOT NULL,
    food_stamps_year1 BOOLEAN NOT NULL,
    food_stamps_year2 BOOLEAN NOT NULL,
    ssi_year1 BOOLEAN NOT NULL,
    ssi_year2 BOOLEAN NOT NULL,
    tanf_year1 BOOLEAN NOT NULL,
    tanf_year2 BOOLEAN NOT NULL,
    wic_year1 BOOLEAN NOT NULL,
    wic_year2 BOOLEAN NOT NULL
);
CREATE TABLE retirement
(
    user_id INT PRIMARY KEY REFERENCES users ON DELETE CASCADE,
    tax_deferred_plan BOOLEAN NOT NULL,
    employer_sponsored_plan BOOLEAN NOT NULL,
    civil_service_or_state_sponsored_plan BOOLEAN NOT NULL,
    union_sponsored_plan BOOLEAN NOT NULL,
    military_sponsored_plan BOOLEAN NOT NULL,
    other_plan BOOLEAN NOT NULL,
    total_value INT NOT NULL CHECK (total_value >= 0)
);
CREATE TABLE taxReturns
(
    user_id INT PRIMARY KEY REFERENCES users ON DELETE CASCADE,
    is_manual BOOLEAN NOT NULL,
    form_link TEXT
);
CREATE TABLE housing_situations
(
    id SERIAL PRIMARY KEY,
    housing_situation VARCHAR(20) NOT NULL UNIQUE CHECK (housing_situation IN ('own home', 'rent home', 'live with others','housing provided'))
);
CREATE TABLE households
(
    user_id INT PRIMARY KEY REFERENCES users ON DELETE CASCADE,
    housing_situation_id INT NOT NULL REFERENCES housing_situations,
    purchase_year DATE CHECK (purchase_year <= CURRENT_DATE),
    purchase_price INT CHECK (purchase_price >= 0),
    current_market_value INT CHECK (current_market_value >= 0),
    primary_mortgage INT CHECK (primary_mortgage >= 0),
    amount_owed INT CHECK (amount_owed >= 0),
    monthly_payment INT NOT NULL CHECK (monthly_payment >= 0)
);
CREATE TABLE dependents
(
    user_id INT PRIMARY KEY REFERENCES users ON DELETE CASCADE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL CHECK (date_of_birth <= CURRENT_DATE),
    relationship_to_student_id INT REFERENCES relationships_to_student ON DELETE RESTRICT,
    grade_level_year1 VARCHAR(50) NOT NULL,
    grade_level_year2 VARCHAR(50) NOT NULL,
    tuition_year1 INT CHECK (tuition_year1 >= 0),
    tuition_year2 INT CHECK (tuition_year2 >= 0)
);
CREATE TABLE business_types
(
    id SERIAL PRIMARY KEY,
    business_type VARCHAR(50) NOT NULL UNIQUE CHECK (business_type IN ('corporation', 'partnership', 'sole proprietorship'))
);
CREATE TABLE business_tax_locations
(
    id SERIAL PRIMARY KEY,
    tax_location VARCHAR(100) NOT NULL UNIQUE CHECK (tax_location IN ('schedule c', 'schedule e','1065','1120','1120-s','other'))
);
CREATE TABLE businesses
(
    user_id INT PRIMARY KEY REFERENCES users ON DELETE CASCADE,
    business_name VARCHAR(255) NOT NULL,
    street_address VARCHAR(100) NOT NULL,
    unit VARCHAR(20),
    city VARCHAR(50) NOT NULL,
    address_state VARCHAR(50),
    address_zip VARCHAR(20),
    business_type_id INT NOT NULL REFERENCES business_types ON DELETE RESTRICT,
    business_product VARCHAR(50) NOT NULL,
    percent_ownership INT NOT NULL CHECK (percent_ownership > 0 AND percent_ownership <= 100),
    date_started DATE NOT NULL CHECK (date_started <= CURRENT_DATE),
    more_than_100_employees BOOLEAN NOT NULL,
    current_market_value INT NOT NULL CHECK (current_market_value >= 0),
    current_amount_owed INT NOT NULL CHECK (current_amount_owed >= 0),
    business_tax_location_id INT NOT NULL REFERENCES business_tax_locations ON DELETE RESTRICT,
    gross_receipts INT NOT NULL CHECK (gross_receipts >= 0),
    total_expenses INT NOT NULL CHECK (total_expenses >= 0)
);
-- CREATE TABLE taxReturnsManual
-- (
--     id SERIAL PRIMARY KEY,
-- );




-- Seed data

-- ENUMS
INSERT INTO business_tax_locations (tax_location) VALUES ('schedule c'), ('schedule e'), ('1065'), ('1120'), ('1120-s'), ('other');
INSERT INTO business_types (business_type) VALUES ('corporation'), ('partnership'), ('sole proprietorship');
INSERT INTO housing_situations (housing_situation) VALUES ('own home'), ('rent home'), ('live with others'), ('housing provided');
INSERT INTO relationships_to_student (relationship_to_student) VALUES ('mother'), ('father'), ('step mother'), ('step father'), ('sibling'), ('stepsibling'), ('spouse'), ('child'), ('grandparent'), ('other');
INSERT INTO highest_education_levels (highest_education_level) VALUES ('middle school'), ('high school'), ('college'), ('unknown');
INSERT INTO marital_statuses (marital_status) VALUES ('never married'), ('married'), ('divorced'), ('widowed');
INSERT INTO user_types (user_type) VALUES ('student'), ('custodial'), ('noncustodial');
INSERT INTO application_types (application_type) VALUES ('regular decision'), ('early decision'), ('early action');
INSERT INTO housing_plans (housing_plan) VALUES ('on campus'), ('off campus'), ('with parents');
INSERT INTO high_school_statuses (high_school_status) VALUES ('diploma'), ('ged'), ('home schooled'), ('none');
-- TODO test accounts with multiple FAFSAs 
-- TODO test deleted accounts 
-- TODO test accounts with deleted FAFSAs 
-- TODO test accounts with graduate students
-- TODO test accounts with independent students
-- TODO test accounts with siblings in college
-- TODO test accounts with 2 parents 1 child
-- TODO test accounts with 1 custodial parent 1 child
-- TODO test accounts with 1 custodial 1 noncustodial 1 child





