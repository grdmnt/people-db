import * as React from 'react'
import axios from 'axios'
import {
  Alert,
  AlertIcon,
  Button,
  Input,
  Table,
  Thead,
  Tbody,
  Tr,
  Th
} from '@chakra-ui/react'

import './index.css'

import {
  flexRender,
  getCoreRowModel,
  getPaginationRowModel,
  useReactTable,
  getSortedRowModel,
  getFilteredRowModel,
} from '@tanstack/react-table'

import {
  rankItem,
} from '@tanstack/match-sorter-utils'

const columns = [
  {
    accessorKey: 'first_name',
    header: () => 'First Name',
  },
  {
    accessorKey: 'last_name',
    header: () => 'Last Name',
  },
  {
    accessorKey: 'locations',
    header: () => 'Location',
  },
  {
    accessorKey: 'species',
    header: () => 'Species',
  },
  {
    accessorKey: 'gender',
    header: () => 'Gender',
  },
  {
    accessorKey: 'affiliations',
    header: () => 'Affiliations',
  },
  {
    accessorKey: 'weapon',
    header: () => 'Weapon',
  },
  {
    accessorKey: 'vehicle',
    header: () => 'Vehicle',
  },
]

const baseURL = "http://localhost:3000/people";

const fuzzyFilter = (row, columnId, value, addMeta) => {
  const itemRank = rankItem(row.getValue(columnId), value)

  addMeta({
    itemRank,
  })

  return itemRank.passed
}

function App() {
  const [data, setData] = React.useState(() => [])
  const [csvFile, setCsvFile] = React.useState(null)
  const [sorting, setSorting] = React.useState([])
  const [globalFilter, setGlobalFilter] = React.useState('')
  const [notice, setNotice] = React.useState('')

  const table = useReactTable({
    data,
    columns,
    state: {
      sorting,
      globalFilter,
    },
    onSortingChange: setSorting,
    getSortedRowModel: getSortedRowModel(),
    getCoreRowModel: getCoreRowModel(),
    getPaginationRowModel: getPaginationRowModel(),
    onGlobalFilterChange: setGlobalFilter,
    getFilteredRowModel: getFilteredRowModel(),
    globalFilterFn: fuzzyFilter,
    debugTable: true,
  })

  React.useEffect(() => {
    axios.get(baseURL).then((response) => {
      setData(response.data);
    });
  }, []);

  const importFile = () => {
    const data = new FormData()
    data.append('file', csvFile)

    axios.post(baseURL + '/import', data, { headers: { "Content-Type": "multipart/form-data" } }).then(function (res) {

      const result = res.data.table
      let notices = []

      result.imported_data && notices.push(`Successful imported data: ${result.imported_data.length}.`)
      result.failed_rows && notices.push(`Failed rows: ${result.failed_rows.map(x => `${x[0]} - ${x[1]}`).join(', ')}.`)

      setNotice(notices.join('\n'))

      axios.get(baseURL).then((response) => {
        setData(response.data);
      });
    })
    .catch(function () {
      setNotice('Something went wrong, please try again.')
    });
  }

  const uploadFile = (event) => {
    setCsvFile(event.target.files[0])
  }

  return (
    <div >
      {notice &&

        <Alert status='info'>
          <AlertIcon />
          {notice}
        </Alert>
      }

      <div className="global-filter">
        <DebouncedInput
          value={globalFilter ?? ''}
          onChange={value => setGlobalFilter(String(value))}
          className="p-2 font-lg shadow border border-block"
          placeholder="Search all columns..."
        />
      </div>
      <Table>
      <Thead>
          {table.getHeaderGroups().map(headerGroup => (
            <Tr key={headerGroup.id}>
              {headerGroup.headers.map(header => {
                return (
                  <Th key={header.id} colSpan={header.colSpan}>
                    {header.isPlaceholder ? null : (
                      <div
                        {...{
                          className: header.column.getCanSort()
                            ? 'cursor-pointer select-none'
                            : '',
                          onClick: header.column.getToggleSortingHandler(),
                        }}
                      >
                        {flexRender(
                          header.column.columnDef.header,
                          header.getContext()
                        )}
                        {{
                          asc: ' 🔼',
                          desc: ' 🔽',
                        }[header.column.getIsSorted()] ?? null}
                      </div>
                    )}
                  </Th>
                )
              })}
            </Tr>
          ))}
        </Thead>
        <Tbody>
          {table.getRowModel().rows.map(row => {
            return (
              <tr key={row.id}>
                {row.getVisibleCells().map(cell => {
                  return (
                    <td key={cell.id}>
                      {flexRender(
                        cell.column.columnDef.cell,
                        cell.getContext()
                      )}
                    </td>
                  )
                })}
              </tr>
            )
          })}
        </Tbody>
      </Table>
      <div className="flex items-center gap-2">
        <Button
          className="border rounded p-1"
          onClick={() => table.setPageIndex(0)}
          disabled={!table.getCanPreviousPage()}
        >
          {'<<'}
        </Button>
        <Button
          className="border rounded p-1"
          onClick={() => table.previousPage()}
          disabled={!table.getCanPreviousPage()}
        >
          {'<'}
        </Button>
        <Button
          className="border rounded p-1"
          onClick={() => table.nextPage()}
          disabled={!table.getCanNextPage()}
        >
          {'>'}
        </Button>
        <Button
          className="border rounded p-1"
          onClick={() => table.setPageIndex(table.getPageCount() - 1)}
          disabled={!table.getCanNextPage()}
        >
          {'>>'}
        </Button>
        <span className="flex items-center gap-1">
          <div>Page</div>
          <strong>
            {table.getState().pagination.pageIndex + 1} of{' '}
            {table.getPageCount()}
          </strong>
        </span>
      </div>
      <div>
        <strong>Import Data:</strong>
        <br />
        <input type="file" name="file" onChange={uploadFile}/>
        <Button type="button" className="btn btn-success btn-block" onClick={importFile}>Import</Button>
      </div>
    </div>
  )
}

function DebouncedInput({
  value: initialValue,
  onChange,
  debounce = 500,
  ...props
}) {
  const [value, setValue] = React.useState(initialValue)

  React.useEffect(() => {
    setValue(initialValue)
  }, [initialValue])

  React.useEffect(() => {
    const timeout = setTimeout(() => {
      onChange(value)
    }, debounce)

    return () => clearTimeout(timeout)
  }, [value])

  return (
    <Input {...props} value={value} onChange={e => setValue(e.target.value)} />
  )
}

export default App;