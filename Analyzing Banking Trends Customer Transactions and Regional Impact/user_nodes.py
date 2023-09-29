import pandas as pd
import warnings
warnings.filterwarnings("ignore")


# Function to read the CSV file into a DataFrame
def read_csv():
    # read the user_nodes.csv file using pandas library and return it
    df = pd.read_csv('user_nodes.csv')
    return df


# Function to check for null (missing) values in the DataFrame
def check_null_values():
    # do not edit the predefined function name
    df = read_csv()
    # Check for null values using the isnull() method and sum them for each column
    null_values = df.isnull().sum()
    return null_values

# Function to check for duplicate rows in the DataFrame


def check_duplicates():
    # do not edit the predefined function name
    df = read_csv()
    # Calculate the number of duplicate rows using the duplicated() method and sum them
    duplicates = df.duplicated().sum()
    return duplicates


# Function to drop duplicate rows from the DataFrame
def drop_duplicates():
    # do not edit the predefined function name
    df = read_csv()
    # Drop duplicate rows using the drop_duplicates() method with inplace=True
    df.drop_duplicates(inplace=True)
    return df


def data_cleaning():

    df = drop_duplicates()

    # Step 3: Drop specified columns from the DataFrame("has_loan", "is_act")
    df.drop(['has_loan', 'is_act'], axis=1, inplace=True)
    # Rename columns names id_,area_id_,node_id_,act_date',deact_date to  consumer_id,region_id,node_id,start_date,end_date
    df.rename(columns={'id_': 'consumer_id', 'area_id_': 'region_id', 'node_id_': 'node_id',
              'act_date': 'start_date', 'deact_date': 'end_date'}, inplace=True)
    
    # Step 4: Convert the start_date and end_date columns to datetime format
    df['start_date'] = pd.to_datetime(df['start_date'], format='%d-%m-%Y').dt.strftime('%Y-%m-%d')


    df['end_date'] = pd.to_datetime(df['end_date'], format='%d-%m-%Y').dt.strftime('%Y-%m-%d')

    df.to_csv('user_nodes_cleaned.csv', index=False)
    return df


def main():
    data_cleaning()


if __name__ == "__main__":
    main()