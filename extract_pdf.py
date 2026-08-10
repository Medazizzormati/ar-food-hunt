import PyPDF2

pdf = open(r'c:\Users\medaz\Downloads\AR_Food_Hunt_Proposal.pdf', 'rb')
reader = PyPDF2.PdfReader(pdf)

for i, page in enumerate(reader.pages):
    print(f'=== PAGE {i+1} ===')
    print(page.extract_text())
    print()
