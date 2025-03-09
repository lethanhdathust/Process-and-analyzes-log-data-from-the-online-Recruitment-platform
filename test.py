import pandas as pd
import datetime
import random

# Sample DataFrame
data = {
    'Contract': ['AGAAA0335', 'AGAAA0338', 'AGAAA0345', 'AGAAA0346', 'AGAAA0350', 
                 'YBFDN0001', 'YBFDN0003', 'qad014538', 'qad014538', 'qad014541'],
    'AppName': ['CHANNEL', 'CHANNEL', 'CHANNEL', 'CHANNEL', 'CHANNEL', 
                'KPLUS', 'CHANNEL', 'CHILD', 'CHANNEL', 'CHANNEL'],
    'total_duration': [82149, 5805, 178, 86400, 15514, 932, 37766, 1189, 5312, 86400]
}

df = pd.DataFrame(data)

# Define the mapping
mapping = {
    'CHANNEL': 'Truyền Hình',
    'CHILD': 'Thiếu Nhi',
    'SPORT': 'Thể Thao',
    'RELAX': 'Giải Trí',
    'DSHD': 'Truyền Hình',
    'KPLUS': 'Thể Thao'
}

# Apply transformation
start = datetime.datetime.now()
df['category'] = df['AppName'].map(lambda x: mapping.get(x, 'Phim Truyện'))
end = datetime.datetime.now()

# Print the output
print("\nTransformed DataFrame:")
print(df)

# Print execution time
print("\nThe task took {} seconds to finish".format((end - start).total_seconds()))
